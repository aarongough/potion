require 'spec_helper'

include Potion

describe Page do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/")
    @site = Site.new(@fixture_path + "/test-site")
  end
  
  describe '.new' do    
    it "should load the metadata from the Page" do
      page = Page.new(@fixture_path + "/test-site/blog.haml", @site)
      page.metadata.should == {
        "layout" => "main",
        "title" => "blah something"
      }
    end
    
    it "should correctly load the Page's content" do
      page = Page.new(@fixture_path + "/test-site/blog.haml", @site)
      page.content.should == "\nTest456"
    end
    
    it "should correctly associate the Page with the layout declared in the metadata" do
      page = Page.new(@fixture_path + "/test-site/blog.haml", @site)
      layout = Layout.new(@fixture_path + "/test-site/_layouts/main.haml", @site)
      page.layout.should == layout
    end
  end
  
  describe '#==' do
    context "when the two Pages are identical" do
      it "should return true" do
        page1 = Page.new(@fixture_path + "/test-site/blog.haml", @site)
        page2 = Page.new(@fixture_path + "/test-site/blog.haml", @site)
        page1.should == page2
      end
    end
    
    context "when the two Pages are different" do
      it "should return false" do
        page1 = Page.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
        page2 = Page.new(@fixture_path + "/test-site/blog.haml", @site)
        page1.should_not == page2
      end
    end
  end
  
  describe '#render' do
    it "should render the page in it's template" do
      page = Page.new(@fixture_path + "/test-site/blog.haml", @site)
      page.render.should == "Main layout\nTest456\n"
    end
  end
end