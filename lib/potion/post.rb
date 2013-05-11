class Potion::Post < Potion::Renderable

  attr_accessor :static_files
  
  def initialize(path, site)
    @static_files = Dir[File.dirname(path) + "/*.*"].reject {|x| x == path}.map {|x| Potion::StaticFile.new(x, site)}
                    
    @relative_output_path = path.gsub("_posts/", "")
                            
    super(path, site)
  end
  
  def write
    @static_files.each {|file| file.write }
    super
  end
end