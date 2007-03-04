require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/scrubber_data.rb'

class HpricotScrubTest < Test::Unit::TestCase

  def setup
    @clean = Hpricot(MARKUP).scrub.inner_html
    @config = YAML.load_file('examples/config.yml')
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
    # using the divisor search throws warnings in test
    assert_tag_count(doc, 'a', 0)
    assert_tag_count(doc, 'p', full.search('//p').size)
    assert_tag_count(doc, 'div', full.search('//div').size)
    assert_tag_count(doc, 'img', full.search('//img').size)
    assert_tag_count(doc, 'br', full.search('//br').size)
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
end
