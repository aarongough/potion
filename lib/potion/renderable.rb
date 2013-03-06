module Potion::Renderable  
  def load_content_and_metadata
    @content  = File.open(path) {|file| file.read}
    @metadata = YAML.load(@content.slice!(/---([^(\-\-\-)]*)---/, 0))
  end
  
  def render
    Haml::Engine.new(@layout.content).render(self) do
      Haml::Engine.new(content).render(self)
    end
  end
  
  
end