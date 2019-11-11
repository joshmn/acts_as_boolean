$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "acts_as_boolean/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "ActsAsBoolean"
  spec.version     = ActsAsBoolean::VERSION
  spec.authors     = ["Josh Brody"]
  spec.email       = ["josh@josh.mn"]
  spec.homepage    = "https://github.com/joshmn/acts_as_boolean"
  spec.summary     = "Treat time-y columns like booleans."
  spec.description = spec.summary
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.3"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'rspec', '~> 3.0'
end
