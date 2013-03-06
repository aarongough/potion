# -*- encoding: utf-8 -*-
require File.expand_path("../lib/potion/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "potion"
  s.version     = Potion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aaron Gough"]
  s.email       = ["aaron@aarongough.com"]
  s.homepage    = "http://github.com/aarongough/potion"
  s.summary     = "A static site generator that supports code, photos and files."
  s.description = "A static site generator that supports code, photos and files."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "potion"

  s.add_dependency "bundler", ">= 1.0.0"
  s.add_dependency "haml", ">= 4.0.0"
  s.add_dependency "commander", ">= 4.1.3"

  s.add_development_dependency "rspec", "~> 2"
  s.add_development_dependency "rake"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end