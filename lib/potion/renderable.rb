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
    @relative_output_path = @relative_output_path.gsub(File.extname(path), "") unless self.is_html?

    @output_path = File.join(@site.destination_path, @relative_output_path)
  end
  
  def load_content_and_metadata
    @content  = File.open(path) {|file| file.read}
    begin
      @metadata = YAML.load(@content.slice!(/\A(---\s*\n.*?\n?)^(---\s*$\n?)/m, 0))
    rescue Psych::SyntaxError
      raise "\n\nERROR: Invalid YAML frontmatter in file: #{@path}\n\n"
    end
  end
  
  def render
    @site.class.extensions.each do |extension|
      extension.new.process(self)
    end
    
    layout = Tilt.new(@layout.path) { @layout.content}
    
    if self.is_html?
      layout.render(self) do
        @content
      end
    else
      item = Tilt.new(@path) { @content }
      layout.render(self) do
        item.render(self)
      end
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
  
  def title
    return self.metadata["title"] unless self.metadata["title"].nil?
    
    filename = File.split(@path)[1]
    filename.gsub!(/\d+-\d+-\d+-/, "")
    filename.gsub!(File.extname(filename), "")
    filename.gsub!(File.extname(filename), "") unless self.is_html?
    filename.gsub!("-", " ")
    filename[0].upcase + filename[1..-1]
  end
  
  def is_html?
    File.extname(@path) == ".html"
  end
end