#
# This test case tests HpricotScrub features that were present in version 0.2.3 before
# introduction of more fine-grained filtering
#
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/scrubber_data.rb'

class OldHpricotScrubTest < Test::Unit::TestCase

  def setup
    @clean = Hpricot(MARKUP).scrub.inner_html
    @config = YAML.load_file('examples/old_config.yml')

    # add some tags that most users will probably want
    @config_full = @config.dup
    %w(body head html).each { |x| @config_full[:allow_tags].push(x) }
  end

  def test_full_markup_partial_scrub
    full = Hpricot(MARKUP)
    full_markup = '<html><head></head><body>' + MARKUP + '</body></html>'
    doc = Hpricot(full_markup).scrub(@config_full)
    partial_scrub_common(doc, full)
  end

  def test_full_scrub
    doc = Hpricot(MARKUP).scrub
    # using the divisor search throws warnings in test
    assert_tag_count(doc, 'a', 0)
    assert_tag_count(doc, 'p', 0)
    assert_tag_count(doc, 'img', 0)
    assert_tag_count(doc, 'br', 0)
    assert_tag_count(doc, 'div', 0)
    assert_tag_count(doc, 'script', 0)
  end

  def test_partial_scrub
    full = Hpricot(MARKUP)
    doc = Hpricot(MARKUP).scrub(@config)
    partial_scrub_common(doc, full)
  end

  def test_full_doc
    doc = Hpricot(GOOGLE).scrub
    assert_tag_count(doc, 'a', 0)
    assert_tag_count(doc, 'p', 0)
    assert_tag_count(doc, 'img', 0)
    assert_tag_count(doc, 'br', 0)
    assert_tag_count(doc, 'div', 0)
    assert_tag_count(doc, 'script', 0)
  end

  def test_string_scrub
    formatted = MARKUP
    assert formatted.scrub == @clean
    assert formatted == MARKUP
  end

  def test_string_scrub!
    formatted = MARKUP
    assert formatted.scrub! == @clean
    assert formatted == @clean
  end

  def test_decoder
    str = 'some <a href="http://example.com/">example&nbsp;link</a> to nowhere'
    scrubbed_str = str.scrub
    assert scrubbed_str.include?('&nbsp;')

    if defined?(HTMLEntities)
      assert ! scrubbed_str.decode.include?('&nbsp;')

      scrubbed_str.decode!
      assert ! scrubbed_str.include?('&nbsp;')
    end
  end

private
  def partial_scrub_common(doc, full)
    # using the divisor search throws warnings in test
    assert_tag_count(doc, 'a', 0)
    assert_tag_count(doc, 'p', full.search('//p').size)
    assert_tag_count(doc, 'div', full.search('//div').size)
    assert_tag_count(doc, 'img', full.search('//img').size)
    assert_tag_count(doc, 'br', full.search('//br').size)
    assert_tag_count(doc, 'script', 0)
  end
end
