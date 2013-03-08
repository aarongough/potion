class Potion::Post
  include Potion::Renderable
  include Potion::Helpers
  
  attr_accessor :path, :static_files, :site, :metadata, :content, :layout, :output_path, :relative_output_path
  
  def initialize(path, site)
    @path         = path
    @site         = site
    @static_files = Dir[File.dirname(@path) + "/*.*"].
                    reject {|x| x == @path}.
                    map {|x| Potion::StaticFile.new(x, @site)}
                    
    load_content_and_metadata
    @layout = @site.find_layout_by_name(@metadata["layout"])
    @relative_output_path = @path.gsub(@site.base_path, "").
                            gsub(File.extname(@path), "").
                            gsub("_posts/", "")
    @output_path = File.join(@site.destination_path, @relative_output_path)
  end
  
  def ==(other)
    self.class.name == other.class.name &&
    @path == other.path && 
    @static_files == other.static_files && 
    @site == other.site
  end
end