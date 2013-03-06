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
end