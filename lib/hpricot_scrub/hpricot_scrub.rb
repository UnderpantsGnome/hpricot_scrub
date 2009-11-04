require 'rubygems'

if defined?(gem)
  gem('hpricot', '>= 0.5')
else
  require_gem('hpricot', '>= 0.5')
end

require 'hpricot'

module Hpricot

  class Scrub

    def self.normalize_config(config) #:nodoc:#
      config = {} unless config.is_a?(Hash)

      return config if config[:normalized]

      config = {

        # Legacy config keys:
        :remove_tags => [],
        :allow_tags => [],
        :allow_attributes => [],

        # New fine-grained hotness:
        :elem_rules => {
          "script"  =>  false,
          "style"  =>  false
        },
        :default_elem_rule => :strip,
        :default_comment_rule => false,
        :default_attribute_rule => false

      }.merge(config)

      #
      # Merge+delete legacy config keys
      #
      # :remove_tags -> :elem_rules (false)
      (config.delete(:remove_tags) || []).each do |tag|
        config[:elem_rules][tag] = false unless config[:elem_rules].has_key?(tag)
      end
      # :allow_tags -> :elem_rules (true)
      (config.delete(:allow_tags) || []).each do |tag|
        config[:elem_rules][tag] = true unless config[:elem_rules].has_key?(tag)
      end
      # :allow_attributes -> :default_attribute_rule (procs)
      (config.delete(:allow_attributes) || []).each do |attribute|
        #
        # Add it to the default attribute rule
        #
        old_rule = config[:default_attribute_rule]
        config[:default_attribute_rule] = Proc.new do |parent_element, key, value|
          if key == attribute
            true
          else
            Scrub::keep_attribute?(parent_element, key, value, old_rule)
          end
        end
      end

      config[:normalized] = true
      return config
    end

    #
    # Takes:
    #
    #  An element
    #  An attribute key found in that element
    #  The attribute value attached to the key
    #  An attribute rule
    #
    # Checks the rule aginst the attribute and returns:
    #
    #  true = the attribute should be kept
    #  false = the attribute should NOT be kept
    #
    # Acceptable attribute rules are:
    #
    #  true: Keep the attribute without inspection
    #  a String: Attribute value must be the same as the string
    #  an Array: Attribute key must exist in the array
    #  a Regexp: Attribute value must match the regexp
    #  a Hash: The attribute key is found in the hash, and the value is considered a new rule and follows these same rules via recursion
    #  a Proc: The Proc is called with arguments (parent_element, key, value), the returned value is considered a new rule and follows these same rules via recursion
    #  otherwise: Remove the attribute
    #
    def self.keep_attribute?(parent_element, key, value, attribute_rule)

      if attribute_rule == true
        keep = true
      elsif attribute_rule.is_a?(String)
        keep = (attribute_rule == value)
      elsif attribute_rule.is_a?(Array)
        keep = attribute_rule.include?(key)
      elsif attribute_rule.is_a?(Regexp)
        keep = attribute_rule.match(value)
      elsif attribute_rule.is_a?(Hash)
        # Allow hash value to be new rule via recursion
        new_rule = attribute_rule[key]
        keep = keep_attribute?(parent_element, key, value, new_rule)
      elsif attribute_rule.is_a?(Proc)
        # Allow the proc to return a new rule - recurse:
        new_rule = attribute_rule.call(parent_element, key, value)
        keep = keep_attribute?(parent_element, key, value, new_rule)
      else
        # Err on the side of caution
        keep = false
      end

      return keep

    end

    module Scrubbable
      def scrubbable?
        ! [ Hpricot::Text,
            Hpricot::BogusETag,
          ].include?(self.class) && self.respond_to?(:scrub)
      end
    end

  end

  class Elements
    def strip
      each { |x| x.strip }
    end

    def strip_attributes(safe=[])
      each { |x| x.scrub_attributes(safe) }
    end
  end

  class DocType
    include Scrub::Scrubbable
  end

  class BogusETag
    include Scrub::Scrubbable
  end

  class Text
    include Scrub::Scrubbable
  end

  class BaseEle
    include Scrub::Scrubbable
  end

  class CData
    include Scrub::Scrubbable
  end

  class ProcIns
    include Scrub::Scrubbable
  end

  class Comment
    include Scrub::Scrubbable

    def remove
      parent.children.delete(self)
    end

    #
    # Scrubs this comment according to the given config
    # If the config key :default_comment_rule is true, the comment is kept. Otherwise it's removed.
    #
    def scrub(config = nil)
      config = Scrub::normalize_config(config)
      rule = config[:default_comment_rule]
      remove unless rule
      return true
    end

  end

  class Elem
    include Scrub::Scrubbable

    def remove
      parent.children.delete(self)
    end

    def strip
      if (i = inner_html) != ""
        swap(i)
      else
        remove
      end
    end

    #
    # Scrubs the element according to the given config
    # The relevant config key is :elem_rules.  It is expected to be a Hash having String HTML tag names as keys, and a rule as values
    # The rule value dictates what happens to the element.  The following logic is used:
    #   If the rule is false/nil, the element is removed along with all it's children
    #   If the rule is :strip, the element is stripped (the element itself is deleted and its children are promoted upwards to where it was)
    #   If the rule is a proc, the proc is called (and given the element itself) - the proc's expected to return a valid rule that matches this documentation
    #   Otherwise the element is kept
    #
    #  If the element name (HTML tag) was not found in :elem_rules, the default rule in config key :default_elem_rule is used
    #
    # After the above is done, if the element was kept, it's time to clean up its attributes so scrub_attributes is called.  The rule is passed to it as it's assumed to be the attribute rules (see Hpricot::Scrub.keep_attribute?) to apply to the attributes, UNLESS the rule was explicitly "true", in which case the config key :default_attribute_rule is passed.
    #
    # This is recursive and will do all the above to all the children of the element as well.
    #
    def scrub(config = nil)

      config = Scrub::normalize_config(config)

      (children || []).reverse.each do |child|
        child.scrub(config) if child.scrubbable?
      end

      rule = config[:elem_rules].has_key?(name) ? config[:elem_rules][name] : config[:default_elem_rule]

      while rule.is_a?(Proc)
        rule = rule.call(self)
      end

      if !rule
        remove
      elsif rule == :strip
        strip
      else
        # Positive rule
        # Keep the element
        # On to attributes
        scrub_attributes(rule == true ? config[:default_attribute_rule] : rule)
      end

      return self
    end

    #
    # Loops over all the attributes on this element, and removes any which Hpricot::Scrub.keep_attribute? returns false for
    #
    def scrub_attributes(attribute_rule = nil)
      if attributes
        attributes.each do |key, value|
          remove_attribute(key) unless Scrub.keep_attribute?(self, key, value, attribute_rule)
        end
      end
      return true
    end

  end #class Elem

  class Doc

    #
    # Scrubs the Hpricot document by removing certain elements and attributes
    # according to the passed-in config
    # WARNING: This is destructive.  If you want to keep your document untouched use a duplicate copy
    # See the documentation on Hpricot::Elem#scrub for documentation of config
    #
    def scrub(config=nil)
      config = Scrub::normalize_config(config)
      (children || []).reverse.each do |child|
        child.scrub(config) if child.scrubbable?
      end
      return self
    end

  end #class Doc

end

class String
  def scrub!(config=nil)
    self.gsub!(/^(\n|.)*$/, Hpricot(self).scrub(config).inner_html)
  end

  def scrub(config=nil)
    dup.scrub!(config)
  end
end

begin
  require 'htmlentities'

  module Hpricot
    class Scrub
      @coder = HTMLEntities.new
      class << self
        def entifier; @coder end
      end
    end
  end

  class String
    def decode!
      self.gsub!(/^(\n|.)*$/, Hpricot::Scrub.entifier.decode(self))
    end

    def decode
      dup.decode!
    end
  end

rescue LoadError; end
