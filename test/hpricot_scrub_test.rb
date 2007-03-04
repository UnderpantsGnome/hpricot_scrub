require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/scrubber_data.rb'

class HpricotScrubTest < Test::Unit::TestCase

  def setup
  end
  
  def test_full_scrub
    # using the divisor search throws warnings in test
    doc = Hpricot(MARKUP).scrub
    assert doc.search('//a').size == 0 
    assert doc.search('//p').size == 0 
    assert doc.search('//img').size == 0 
    assert doc.search('//br').size == 0 
    assert doc.search('//script').size == 0 
  end
end
