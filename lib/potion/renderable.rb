module Potion::Renderable  
  def load_content_and_metadata
    @content  = File.open(path) {|file| file.read}
    @metadata = YAML.load(@content.slice!(/---([^(\-\-\-)]*)---/, 0))
  end
  
  def render
    layout  = Tilt.new(@layout.path) { @layout.content}
    item    = Tilt.new(@path) { @content }
    
    layout.render(self) do
      item.render(self)
    end
  end
  
  def load_extensions
    @site.extensions.each do |extension|
      instance_eval File.open(extension) {|stream| stream.read}
    end
  end
  
  def register_extension(name, &block)
    @extensions ||= {}
    @extensions[name.to_sym] = block
  end
  
  def method_missing(name, *args)
    super unless @extensions.has_key?(name.to_sym)
    @extensions[name.to_sym].call(args)
  end
  
  def write_to(destination_root)
    relative_path = @path.gsub(@site.base_path, "")
    
    destination_path = File.join(destination_root, relative_path)
    destination_path.gsub!(File.extname(@path), "")
    destination_path.gsub!("_posts/", "") if self.is_a?(Potion::Post)
    
    FileUtils.mkdir_p(File.split(destination_path)[0])
    File.open(destination_path, "w+") do |stream|
      stream.puts self.render
    end
  end
end