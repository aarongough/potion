module Potion::Renderable  
  def load_content_and_metadata
    @content  = File.open(path) {|file| file.read}
    @metadata = YAML.load(@content.slice!(/---([^(\-\-\-)]*)---/, 0))
  end
  
  def render
    Haml::Engine.new(@layout.content).render do
      Haml::Engine.new(content).render
    end
  end
  
  def write_to(destination_root)
    relative_path = @path.gsub(@site.path, "")
    destination_path = File.join(destination_root, relative_path).gsub(File.extname(@path), ".html")
    FileUtils.mkdir_p(File.split(destination_path)[0])
    File.open(destination_path, "w+") do |stream|
      stream.puts self.render
    end
  end
end