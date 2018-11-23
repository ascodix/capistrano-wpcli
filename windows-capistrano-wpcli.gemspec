# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "windows/capistrano/wpcli/version"

Gem::Specification.new do |spec|
  spec.name          = "windows-capistrano-wpcli"
  spec.version       = Windows::Capistrano::Wpcli::VERSION
  spec.authors       = ["ascodix"]
  spec.email         = ["stephane-albuisson@gmail.com"]

  spec.summary       = "Capistrano for wp-cli"
  spec.description   = "Capistrano for wp-cli"
  spec.homepage      = "http://www.stephane-albuisson.com"
  spec.license       = "MIT"



  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_dependency 'capistrano', '~> 3.1'
end
