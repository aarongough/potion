require 'spec_helper'

describe '#category' do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/test-site")
    @destination_path = @fixture_path + "/_site"
    @site = Site.new(@fixture_path, @destination_path)
  end
  
  it "should return all the posts in the site that live in the 'blog' directory" do
    @site.posts.first.category("blog").should == [
      Post.new(@fixture_path + "/blog/_posts/2013-03-04-a-new-thing/a-new-thing.html.haml", @site)
    ]
  end
end