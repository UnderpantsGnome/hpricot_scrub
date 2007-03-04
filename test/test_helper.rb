require 'test/unit'
require File.dirname(__FILE__) + '/../lib/hpricot_scrub'

def assert_tag_count(doc, tag, expected)
  found = doc.search("//#{tag}").size
  assert found == expected,
    "Expected to find #{expected} '#{tag}' tag(s), found #{found}"
end