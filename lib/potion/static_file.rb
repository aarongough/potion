class Potion::StaticFile
  
  attr_accessor :path, :site, :content, :relative_output_path, :output_path
  
  def initialize(path, site)
    @path = path
    @site = site
    @content = File.open(path) {|stream| stream.read }
    @relative_output_path = @path.gsub(@site.base_path, "").gsub("_posts/", "")
    @output_path = File.join(@site.destination_path, @relative_output_path)
  end
  
  def ==(other)
    self.class.name == other.class.name &&
    @path == other.path && 
    @site == other.site
  end
  
  def render
    @site.class.extensions.each do |extension|
      extension.new.process(self)
    end
    puts self.path
    
    @content
  end
  
  def write
    FileUtils.mkdir_p(File.split(@output_path)[0])
    File.open(@output_path, "w+") do |stream|
      stream.puts self.render
    end
  end
end