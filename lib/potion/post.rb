class Potion::Post
  include Potion::Renderable
  
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
  
  def write_to(destination_root)
    relative_path = @path.gsub(@site.base_path, "")
    destination_path = File.join(destination_root, relative_path).gsub(File.extname(@path), ".html").gsub("_posts/", "")
    
    FileUtils.mkdir_p(File.split(destination_path)[0])
    File.open(destination_path, "w+") do |stream|
      stream.puts self.render
    end
  end
end