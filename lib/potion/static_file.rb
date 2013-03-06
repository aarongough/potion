class Potion::StaticFile
  
  attr_accessor :path, :site, :content
  
  def initialize(path, site)
    @path = path
    @site = site
    @content = File.open(path) {|stream| stream.read }
  end
  
  def ==(other)
    self.class.name == other.class.name &&
    @path == other.path && 
    @site == other.site
  end
  
  def write_to(destination_root)
    relative_path = @path.gsub(@site.path, "")
    destination_path = File.join(destination_root, relative_path)
    FileUtils.mkdir_p(File.split(destination_path)[0])
    File.open(destination_path, "w+") do |stream|
      stream.puts @content
    end
  end
end