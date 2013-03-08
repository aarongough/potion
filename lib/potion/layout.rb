class Potion::Layout
  
  attr_accessor :path, :name, :site, :content
  
  def initialize(path, site)
    @path     = path
    @site     = site
    @name     = File.split(@path)[1].gsub(File.extname(@path), "")
    @content  = File.open(@path) {|stream| stream.read }
  end
  
  def ==(other)
    @path == other.path &&
    @site == other.site
  end
end