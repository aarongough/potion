class Potion::Page
  include Potion::Renderable  
  include Potion::Helpers
  
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
end