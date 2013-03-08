require 'spec_helper'

include Potion

describe Site do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/test-site/")
    @destination_path = @fixture_path + "_site"
  end
  
  describe ".new" do
    context "when no config file is present" do
      it "should raise an error" do
        lambda{
          Site.new(@fixture_path + "../broken-site", @destination_path)
        }.should raise_error
      end
    end
    
    context "when a config file is present" do
      it "should not raise any errors" do
        lambda{
          Site.new(@fixture_path, @destination_path)
        }.should_not raise_error
      end
    end
  end
  
  describe "#find_layouts" do
    it "should return all the layouts in the site" do
      site = Site.new(@fixture_path, @destination_path)
      site.find_layouts.should == [
        Layout.new(@fixture_path + "/_layouts/blog.haml", site),
        Layout.new(@fixture_path + "/_layouts/main.haml", site),
      ]
    end
  end
  
  describe '#find_layout_by_name' do
    it "should return the named layout" do
      site = Site.new(@fixture_path, @destination_path)
      site.find_layout_by_name("main").should == Layout.new(@fixture_path + "/_layouts/main.haml", site)
    end
  end
  
  describe "#find_posts" do
    it "should return all the posts in the site" do
      site = Site.new(@fixture_path, @destination_path)
      site.find_posts.should == [
        Post.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", site),
        Post.new(@fixture_path + "/portfolio/_posts/a-cool-thing/a-cool-thing.html.haml", site),
      ]
    end
  end
  
  describe "#find_pages" do
    it "should return all the pages in the site" do
      site = Site.new(@fixture_path, @destination_path)
      site.find_pages.should == [
        Page.new(@fixture_path + "/blog.html.haml", site)
      ]
    end
  end
  
  describe '#find_static_files' do
    it "should return all the static files in the site" do
      site = Site.new(@fixture_path, @destination_path)
      site.find_static_files.should == [
        StaticFile.new(@fixture_path + "/css/main.css", site),
        StaticFile.new(@fixture_path + "/javascript/main.js", site)
      ]
    end
  end
end