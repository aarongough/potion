class Potion::Post
  include Potion::Renderable
  include Potion::Helpers
  
  attr_accessor :path, :static_files, :site, :metadata, :content, :layout
  
  def initialize(path, site)
    @path         = path
    @site         = site
    @static_files = Dir[File.dirname(@path) + "/*.*"].
                    reject {|x| x == @path}.
                    map {|x| Potion::StaticFile.new(x, @site)}
                    
    load_content_and_metadata
    @layout = @site.find_layout_by_name(@metadata["layout"])
  end
  
  def ==(other)
    self.class.name == other.class.name &&
    @path == other.path && 
    @static_files == other.static_files && 
    @site == other.site
  end
end