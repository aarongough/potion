require 'spec_helper'

include Potion

describe Post do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/")
    @destination_path = @fixture_path + "/test-site/_site"
    @site = Site.new(@fixture_path + "/test-site", @destination_path)
  end
  
  describe '.new' do
    it "should find all the static files associated with the post" do
      post = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
      post.static_files.length.should == 1
      post.static_files.first.should == StaticFile.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/an-extra-thing.txt", @site)
    end
    
    it "should correctly set the post's output path" do
      post = Post.new(@fixture_path + "/test-site/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
      post.output_path.should == File.join(@fixture_path, "/test-site/_site/blog/2013-03-04-a-new-thing/a-new-thing.html")
    end
  end
end