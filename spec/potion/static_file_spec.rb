require 'spec_helper'

include Potion

describe StaticFile do
  before do
    @fixture_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures/")
    @destination_path = @fixture_path + "/test-site/_site"
    @site = Site.new(@fixture_path + "/test-site", @destination_path)
  end
  
  describe '.new' do
    it "should correctly load the static file's content" do
      file = StaticFile.new(@fixture_path + "/test-site/javascript/main.js", @site)
      file.content.should == 'alert("This is JS!");'
    end
    
    it "should correctly set the file's output path" do
      file = StaticFile.new(@fixture_path + "/test-site/javascript/main.js", @site)
      file.output_path.should == File.join(@fixture_path, "/test-site/_site/javascript/main.js")
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
        file1 = StaticFile.new(@fixture_path + "/test-site/javascript/main.js", @site)
        file2 = StaticFile.new(@fixture_path + "/test-site/portfolio/_posts/a-cool-thing/a-cool-thing.html.haml", @site)
        file1.should_not == file2
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