lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eod/version'

Gem::Specification.new do |s|
  s.name        = 'eod'
  s.version     = EOD::VERSION
  s.summary     = 'EOD Historical Data API Library and Command Line'
  s.description = 'Easy to use API for eodhistoricaldata.com Data service with a command line interface'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['eod']
  s.homepage    = 'https://github.com/DannyBen/eod'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.7.0'

  s.add_runtime_dependency 'apicake', '~> 0.1'
  s.add_runtime_dependency 'lp', '~> 0.2'
  s.add_runtime_dependency 'mister_bin', '~> 0.7'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/eod/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/eod/blob/master/CHANGELOG.md',
    'homepage_uri'          => 'https://github.com/DannyBen/eod',
    'source_code_uri'       => 'https://github.com/DannyBen/eod',
    'rubygems_mfa_required' => 'true',
  }
end
