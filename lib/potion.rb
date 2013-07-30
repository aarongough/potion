module Potion
  module Helpers; end
  module Deployers; end
end

require 'rubygems'
require 'bundler/setup'

require 'yaml'
require 'tilt'
require 'fileutils'

require 'potion/renderable'
require 'potion/layout'
require 'potion/static_file'
require 'potion/post'
require 'potion/page'
require 'potion/site'

Dir[File.expand_path(File.join(File.dirname(__FILE__), "/potion/extensions/*.rb"))].each do |file|
  require file
end

