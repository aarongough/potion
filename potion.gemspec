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
  s.add_dependency "tilt", ">= 1.3.4"
  s.add_dependency "commander", ">= 4.1.3"
  s.add_dependency "mini_magick"
  
  s.add_dependency 'asciidoctor', '>= 0.1.0'
  s.add_dependency 'RedCloth'
  s.add_dependency 'bluecloth'
  s.add_dependency 'builder'
  s.add_dependency 'coffee-script'
  s.add_dependency 'contest'
  s.add_dependency 'creole'
  s.add_dependency 'erubis'
  s.add_dependency 'haml', '>= 2.2.11'
  s.add_dependency 'kramdown'
  s.add_dependency 'less'
  s.add_dependency 'liquid'
  s.add_dependency 'markaby'
  s.add_dependency 'maruku'
  s.add_dependency 'nokogiri'
  s.add_dependency 'radius'
  s.add_dependency 'rdiscount'
  s.add_dependency 'rdoc'
  s.add_dependency 'redcarpet'
  s.add_dependency 'sass'
  s.add_dependency 'wikicloth'
  s.add_dependency 'yajl-ruby'
  s.add_dependency 'rdoc'

  s.add_development_dependency "rspec", "~> 2"
  s.add_development_dependency "rake"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end