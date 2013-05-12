require 'spec_helper'

include Potion

describe Renderable do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/test-site/")
    @destination_path = @fixture_path + "_site"
    @site = Site.new(@fixture_path, @destination_path)
  end
  
  describe '.new' do    
    it "should load the metadata from the item" do
      item = Renderable.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
      item.metadata.should == {
        "layout" => "main",
        "title" => "blah something"
      }
    end
    
    it "should correctly load the item's content" do
      item = Renderable.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
      item.content.should == "Test123"
    end
    
    it "should correctly associate the item with the layout declared in the metadata" do
      item = Renderable.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
      layout = Layout.new(@fixture_path + "/_layouts/main.haml", @site)
      item.layout.should == layout
    end
  end
  
  describe '#==' do
    context "when the two Renderables are identical" do
      it "should return true" do
        post1 = Renderable.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
        post2 = Renderable.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
        post1.should == post2
      end
    end
    
    context "when the two Renderables are different" do
      it "should return false" do
        post1 = Renderable.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
        post2 = Renderable.new(@fixture_path + "/portfolio/_posts/a-cool-thing/a-cool-thing.html.haml", @site)
        post1.should_not == post2
      end
    end
  end
  
  describe '#render' do
    it "should render the item in it's template" do
      post = Renderable.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
      post.render.should == "Main layout\nTest123\n"
    end
  end
  
  describe '#title' do
    context "when there is a title in the metadata" do
      it "should return the title from the metadata" do
        post = Renderable.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
        post.title.should == "blah something"
      end
    end
    
    context "when there is no title in the metadata" do
      it "return a human-readable version of the filename" do
        post = Renderable.new(File.expand_path(File.dirname(__FILE__) + "/../fixtures/a-new-thing-2.html"), @site)
        post.title.should == "A new thing 2"
      end
    end
  end
end