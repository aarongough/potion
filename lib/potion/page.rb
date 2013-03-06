class Potion::Page
  include Potion::Renderable  
  
  attr_accessor :path, :site, :content, :metadata, :layout
  
  def initialize(path, site)
    @path     = path
    @site     = site
    load_content_and_metadata
    @layout = @site.find_layout_by_name(@metadata["layout"])
  end
  
  def ==(other)
    self.class.name == other.class.name &&
    @path == other.path &&
    @site == other.site
  end
  
  def write_to(destination_root)
    relative_path = @path.gsub(@site.base_path, "")
    destination_path = File.join(destination_root, relative_path).gsub(File.extname(@path), ".html")
    FileUtils.mkdir_p(File.split(destination_path)[0])
    File.open(destination_path, "w+") do |stream|
      stream.puts self.render
    end
  end
end