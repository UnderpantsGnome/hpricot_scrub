require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'
require 'hoe'
include FileUtils
require File.join(File.dirname(__FILE__), 'lib', 'hpricot_scrub', 'version')

AUTHOR = "UnderpantsGnome"  # can also be an array of Authors
EMAIL = "michael@underpantsgnome.com"
DESCRIPTION = "Scrub HTML with Hpricot"
GEM_NAME = "hpricot_scrub" # what ppl will type to install your gem
RUBYFORGE_PROJECT = "hpricot-scrub" # The unix name for your project
HOMEPATH = "http://trac.underpantsgnome.com/hpricot_scrub/"

NAME = "hpricot_scrub"
REV = nil # UNCOMMENT IF REQUIRED: File.read(".svn/entries")[/committed-rev="(d+)"/, 1] rescue nil
VERS = ENV['VERSION'] || (HpricotScrub::VERSION::STRING + (REV ? ".#{REV}" : ""))
                          CLEAN.include ['**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = ['--quiet', '--title', "hpricot_scrub documentation",
    "--opname", "index.html",
    "--line-numbers",
    "--main", "README",
    "--inline-source"]

class Hoe
  def extra_deps
    @extra_deps.reject { |x| Array(x).first == 'hoe' }
  end
end

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
hoe = Hoe.spec("hpricot_scrub") do |p|
  p.author = AUTHOR
  p.description = DESCRIPTION
  p.email = EMAIL
  p.summary = DESCRIPTION
  p.url = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs = ["test/**/*_test.rb"]
  p.clean_globs = CLEAN  #An array of file patterns to delete on clean.
  p.version = VERS

  # == Optional
  #p.changes        - A description of the release's latest changes.
  p.extra_deps = [['hpricot',  '>= 0.8.1']]
  #p.spec_extras    - A hash of extra values to set in the gemspec.
end
