require 'rubygems'

if defined?(Kernel::gem)
  gem('hpricot', '>= 0.5')
else
  require_gem('hpricot', '>= 0.5')
end

require 'hpricot'

module Hpricot
  module Scrubable
    def scrubable?
      ! [Hpricot::Text, Hpricot::BogusETag].include?(self.class)
    end
  end

  class Elements
    def strip
      each { |x| x.strip }
    end
    
    def strip_attributes(safe=[])
      each { |x| x.strip_attributes(safe) }
    end
  end

  class BaseEle
    include Scrubable
  end

  class Elem
    include Scrubable

    def remove
      parent.children.delete(self)
    end

    def strip
      children.each { |c| c.strip if c.scrubable? }

      if strip_removes?
        remove
      else
        parent.replace_child self, Hpricot.make(inner_html) unless parent.nil?
      end
    end
    
    def strip_attributes(safe=[])
      attributes.each {|atr|
          remove_attribute(atr[0]) unless safe.include?(atr[0])
      } unless attributes.nil?
    end
    
    def strip_removes?
      # I'm sure there are others that shuould be ripped instead of stripped
      attributes && attributes['type'] =~ /script|css/
    end
  end

  class Doc
    def scrub(config={})
      config = {
        :remove_tags => [],
        :allow_tags => [],
        :allow_attributes => []
      }.merge(config)
      
      config[:remove_tags].each { |tag| (self/tag).remove }
      config[:allow_tags].each { |tag|
        (self/tag).strip_attributes(config[:allow_attributes])
      }
      children.reverse.each {|e|
        e.strip if e.scrubable? && ! config[:allow_tags].include?(e.name)
      }
      self
    end
  end
end
