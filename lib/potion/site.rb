class Potion::Site
  include Potion
  attr_accessor :base_path, :config, :pages, :posts, :static_files, :layouts, :files, :base_path
  
  def initialize(base_path)
    @base_path  = base_path
    @config     = load_config
    
    @files        = find_all_files
    @layouts      = find_layouts
    @posts        = find_posts
    @pages        = find_pages
    @static_files = find_static_files
  end
  
  def load_config
    config_path = File.join(@base_path, "_config.yaml")
    raise "No config file found at #{config_path}" unless File.exists?(config_path)
    YAML.load(File.open(config_path))
  end
  
  def find_all_files
    Dir[@base_path + "/**/*.*"]
  end
  
  def find_layouts
    layouts = @files.select {|file| file.include? "_layouts"}
    layouts.map do |layout|
      Layout.new(layout, self)
    end
  end
  
  def find_layout_by_name(name)
    @layouts.select {|layout| layout.name == name}.first
  end
  
  def find_posts
    posts = @files.select {|path| path.include? "_posts"}
    posts = filter_for_yaml_metadata(posts)
    posts.map  do |post| 
      Post.new(post, self)
    end
  end
  
  def find_pages
    pages = @files.reject {|path| path.include?("/_")}
    pages = filter_for_yaml_metadata(pages)
    pages.map do |page| 
      Page.new(page, self)
    end
  end
  
  def find_static_files
    static_files = @files.reject {|path| path.include?("/_")}
    static_files = static_files - filter_for_yaml_metadata(static_files)
    static_files.map do |static_file|
      StaticFile.new(static_file, self)
    end
  end
  
  def write_to(destination_root)
    (@posts + @pages + @static_files).each do |item|
      item.write_to(destination_root)
    end
  end
  
  private
  
  def filter_for_yaml_metadata(files)
    files.select do |file|
      prefix = File.open(file) {|stream| stream.read(3)}
      prefix == "---"
    end
  end
end