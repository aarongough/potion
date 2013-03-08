module Potion::Renderable  
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
    
    if self.is_a?(Potion::Post)
      @static_files.each {|file| file.write }
    end
  end
end