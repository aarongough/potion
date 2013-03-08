require 'spec_helper'

describe '#link_to' do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/test-site")
    @destination_path = @fixture_path + "/_site"
    @site = Site.new(@fixture_path, @destination_path)
  end
  
  context "without a block" do
    it "should return a valid link for a post" do
      post = Post.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
      post.link_to("Test", post).should == "<a href=\"#{post.relative_output_path}\">Test</a>"
    end
    
    it "should return a valid link for a static file" do
      file = StaticFile.new(@fixture_path + "/javascript/main.js", @site)
      @site.posts.first.link_to("Test", file).should == "<a href=\"#{file.relative_output_path}\">Test</a>"
    end
    
    it "should return a valid link for a page" do
      page = Page.new(@fixture_path + "/blog.html.haml", @site)
      page.link_to("Test", page).should == "<a href=\"#{page.relative_output_path}\">Test</a>"
    end
  end
  
  context "with a block" do
    it "should return a valid link for a post" do
      post = Post.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
      post.link_to(post) do
        "Test"
      end.should == "<a href=\"#{post.relative_output_path}\">Test</a>"
    end
  end

end