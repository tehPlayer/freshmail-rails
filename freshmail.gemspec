$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "freshmail/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "freshmail"
  s.version     = Freshmail::VERSION
  s.authors     = ["Marcin Jan Adamczyk"]
  s.email       = ["marcin.adamczyk@subcom.me"]
  s.homepage    = "https://github.com/tehPlayer/freshmail_rails"
  s.summary     = "FreshMail.pl API wrapper"
  s.description = "FreshMail.pl API wrapper"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "faraday", ">= 0.9"
  s.add_dependency "json", ">= 1.8"

  s.add_development_dependency "sqlite3"
end
