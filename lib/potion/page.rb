class Potion::Page
  include Potion::Renderable  
  include Potion::Helpers
  
  attr_accessor :path, :site, :content, :metadata, :layout, :relative_output_path, :output_path
  
  def initialize(path, site)
    @path     = path
    @site     = site
    load_content_and_metadata
    @layout = @site.find_layout_by_name(@metadata["layout"])
    @relative_output_path = @path.gsub(@site.base_path, "").gsub(File.extname(@path), "")
    @output_path = File.join(@site.destination_path, @relative_output_path)
  end
  
  def ==(other)
    self.class.name == other.class.name &&
    @path == other.path &&
    @site == other.site
  end
end