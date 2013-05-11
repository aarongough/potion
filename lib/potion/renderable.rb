class Potion::Renderable  
  include Potion::Helpers
  
  attr_accessor :path, :site, :metadata, :content, :layout, :output_path, :relative_output_path
  
  def initialize(path, site)
    @path         = path
    @site         = site
                    
    load_content_and_metadata
    @layout = @site.find_layout_by_name(@metadata["layout"])
    
    @relative_output_path ||= @path
    @relative_output_path = @relative_output_path.gsub(site.base_path, "")
    @relative_output_path = @relative_output_path.gsub(File.extname(path), "") unless File.extname(path) == ".html"

    @output_path = File.join(@site.destination_path, @relative_output_path)
  end
  
  def load_content_and_metadata
    @content  = File.open(path) {|file| file.read}
    @metadata = YAML.load(@content.slice!(/---([^(\-\-\-)]*)---/, 0))
  end
  
  def render
    @site.class.extensions.each do |extension|
      extension.new.process(self)
    end
    
    layout  = Tilt.new(@layout.path) { @layout.content}
    item    = Tilt.new(@path) { @content }
    
    layout.render(self) do
      item.render(self)
    end
  end
  
  def write    
    FileUtils.mkdir_p(File.split(@output_path)[0])
    File.open(@output_path, "w+") do |stream|
      stream.puts self.render
    end
  end
  
  def ==(other)
    return false unless self.class == other.class
    self.instance_variables.each do |name|
      return false unless self.instance_variable_get(name) == other.instance_variable_get(name)
    end
    
    true
  end
end