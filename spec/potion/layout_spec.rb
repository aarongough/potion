require 'spec_helper'

include Potion

describe Layout do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/")
    @destination_path = @fixture_path + "/test-site/_site"
    @site = Site.new(@fixture_path + "/test-site", @destination_path)
  end
  
  describe '.new' do
    it "should populate the name attribute of the layout" do
      layout = Layout.new(@fixture_path + "/test-site/_layouts/blog.haml", @site)
      layout.name.should == "blog"
    end
    
    it "should load the content of the layout" do
      layout = Layout.new(@fixture_path + "/test-site/_layouts/blog.haml", @site)
      layout.content.should == "Blog layout\n= yield"
    end
  end
end