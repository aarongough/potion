require 'spec_helper'

include Potion

describe Post do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/")
    @site = Site.new(@fixture_path + "/test-site")
  end
  
  describe '.new' do
    it "should find all the static files associated with the post" do
      post = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
      post.static_files.length.should == 1
      post.static_files.first.should == StaticFile.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/an-extra-thing.txt", @site)
    end
    
    it "should load the metadata from the post" do
      post = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
      post.metadata.should == {
        "layout" => "main",
        "title" => "blah something"
      }
    end
    
    it "should correctly load the post's content" do
      post = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
      post.content.should == "\nTest123"
    end
    
    it "should correctly associate the post with the layout declared in the metadata" do
      post = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
      layout = Layout.new(@fixture_path + "/test-site/_layouts/main.haml", @site)
      post.layout.should == layout
    end
  end
  
  describe '#==' do
    context "when the two Posts are identical" do
      it "should return true" do
        post1 = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
        post2 = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
        post1.should == post2
      end
    end
    
    context "when the two Posts are different" do
      it "should return false" do
        post1 = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
        post2 = Post.new(@fixture_path + "/test-site/portfolio/_posts/a-cool-thing/a-cool-thing.haml", @site)
        post1.should_not == post2
      end
    end
  end
  
  describe '#render' do
    it "should render the post in it's template" do
      post = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.haml", @site)
      post.render.should == "Main layout\nTest123\n"
    end
  end
end