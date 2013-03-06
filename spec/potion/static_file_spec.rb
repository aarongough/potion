require 'spec_helper'

include Potion

describe StaticFile do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/")
    @site = Site.new(@fixture_path + "/test-site")
  end
  
  describe '.new' do
    it "should correctly load the static file's content" do
      post = StaticFile.new(@fixture_path + "/test-site/javascript/main.js", @site)
      post.content.should == 'alert("This is JS!");'
    end
  end
  
  describe '#==' do
    context "when the two StaticFiles are identical" do
      it "should return true" do
        file1 = StaticFile.new(@fixture_path + "/test-site/javascript/main.js", @site)
        file2 = StaticFile.new(@fixture_path + "/test-site/javascript/main.js", @site)
        file1.should == file2
      end
    end
    
    context "when the two StaticFiles are different" do
      it "should return false" do
        post1 = StaticFile.new(@fixture_path + "/test-site/javascript/main.js", @site)
        post2 = StaticFile.new(@fixture_path + "/test-site/portfolio/_posts/a-cool-thing/a-cool-thing.haml", @site)
        post1.should_not == post2
      end
    end
  end
  
  describe '#render' do
    it "should return the static file's content" do
      file = StaticFile.new(@fixture_path + "/test-site/javascript/main.js", @site)
      file.render.should == 'alert("This is JS!");'
    end
  end
end