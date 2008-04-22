#
# This test case tests HpricotScrub features that were introduced in version 0.3.0
# introduction of more fine-grained filtering
#
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/scrubber_data.rb'
require "uri"

class HpricotScrubTest < Test::Unit::TestCase

  def setup

    config = {
      :elem_rules => {
        "a" =>  {
          "href"  =>  %r|^https?://|i
        },
        "b" => true,
        "body"  =>  {
          "lang" => %w(en es fr)
        },
        "br"  =>  true,
        "div" =>  %w(id class style),
        "hr"  =>  true,
        "html"  => true,
        "img" =>  {
          "src" =>  Proc.new do |parent_element, attribute_key, attribute_value|
            begin
              uri = URI.parse(attribute_value)
              uri.is_a?(URI::HTTP) && uri.host != /imageshack/i
            rescue
              false
            end
          end,
          "align" =>  "middle",
          "alt" =>  true
        },
        "marquee" =>  :strip,
        "p"  =>  true,
        "script"  => false,
        "span" =>  :strip,
        "strong" => true,
        "style"  => false
      },
      :default_elem_rule => :strip,
      :default_comment_rule => false,
      :default_attribute_rule => false
    }

    @docs = [
      Hpricot(MARKUP),
      Hpricot(GOOGLE)
    ]
    @scrubbed_docs = [
      Hpricot(MARKUP).scrub(config),
      Hpricot(GOOGLE).scrub(config)
    ]

  end

  def test_elem_default_rule_strips
     @scrubbed_docs.each do |doc|
       assert_equal 0, doc.search("//span").length
     end
  end

  def test_elem_rule_keep
     @scrubbed_docs.each_with_index do |doc, i|
       assert_equal @docs[i].search("//a").length, doc.search("//a").length
       assert_equal @docs[i].search("//b").length, doc.search("//b").length
       assert_equal @docs[i].search("//img").length,  doc.search("//img").length
     end
  end

  def test_elem_rule_remove
     @scrubbed_docs.each do |doc|
       assert_equal 0, doc.search("//script").length
       assert_equal 0, doc.search("//style").length
     end
  end

  def test_elem_rule_strip
     @scrubbed_docs.each do |doc|
       assert_equal 0, doc.search("//marquee").length
       assert_equal 0, doc.search("//span").length
     end
  end

  def test_attr_default_rule_removes
     @scrubbed_docs.each do |doc|
       assert_equal 0, doc.search("*[@mce_src]").length
       assert_equal 0, doc.search("*[@target]").length
     end
  end

  def test_attr_rule_true
     @scrubbed_docs.each_with_index do |doc, i|
       assert_equal @docs[i].search("*[@alt]").length, doc.search("*[@alt]").length
     end
  end

  def test_attr_rule_string
     @scrubbed_docs.each_with_index do |doc, i|
       assert_equal @docs[i].search("img[@align='middle']").length, doc.search("img[@align]").length
     end
  end

  def test_attr_rule_regexp
     @scrubbed_docs.each_with_index do |doc, i|
       assert_equal @docs[i].search("a[@href^='http']").length, doc.search("a[@href]").length
     end
  end

  def test_attr_rule_array
     @scrubbed_docs.each_with_index do |doc, i|
       assert_equal @docs[i].search("div[@id]").length, doc.search("div[@id]").length
       assert_equal @docs[i].search("div[@class]").length, doc.search("div[@class]").length
       assert_equal @docs[i].search("div[@style]").length, doc.search("div[@style]").length
     end
  end

  def test_attr_rule_proc
     @scrubbed_docs.each_with_index do |doc, i|
       assert_equal @docs[i].search("img[@src^='http']").length, doc.search("img[@src]").length
     end
  end

end
