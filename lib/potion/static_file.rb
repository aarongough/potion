class Potion::StaticFile
  
  attr_accessor :path, :site
  
  def initialize(path, site)
    @path = path
    @site = site
  end
  
  def ==(other)
    self.class.name == other.class.name &&
    @path == other.path && 
    @site == other.site
  end
end