class Potion::Site
  include Potion
  include Potion::Deployers
  attr_accessor :base_path, :config, :pages, :posts, :static_files, :layouts, :files, :destination_path, :metadata, :fast_build
  
  @@extensions = []
  
  def self.register_extension(klass)
    @@extensions << klass
  end
  
  def self.remove_extension(klass)
    @@extensions = @@extensions - [klass]
  end
  
  def self.extensions
    @@extensions
  end
  
  def initialize(base_path, destination_path, fast_build = false)
    @base_path  = base_path
    @destination_path = destination_path
    @fast_build = fast_build
    
    @config     = load_config
    @metadata   = {}
    
    @files        = find_all_files
    
    load_extensions
    
    @layouts      = find_layouts
    @posts        = find_posts
    @pages        = find_pages
    @static_files = find_static_files
  end
  
  def load_config
    config_path = File.join(@base_path, "_config.yaml")
    raise "No config file found at '#{config_path}'" unless File.exists?(config_path)
    config = YAML.load(File.open(config_path))
    return {} if config == false
    config
  end
  
  def find_all_files
    Dir[@base_path + "/**/*"].reject {|x| File.directory?(x)}
    
  end
  
  def load_extensions
    site_extensions = @files.select {|path| path.include?("_extensions") && File.extname(path) == ".rb" }
    site_extensions.each do |extension|
      require extension
    end
  end
  
  def find_layouts
    layouts = @files.select {|path| path.include? "_layouts"}
    layouts.map do |layout|
      Layout.new(layout, self)
    end
  end
  
  def find_layout_by_name(name)
    @layouts.select {|layout| layout.name == name}.first
  end
  
  def find_posts
    posts = @files.select {|path| path.include?("_posts")}
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
  
  def write
    puts "*** Building...\n"
    
    (@posts + @pages + @static_files).each do |item|
      item.write
    end
  end
  
  def deploy_to(target)
    self.send("deploy_to_#{target}", @destination_path)
  end
  
  private
  
  def filter_for_yaml_metadata(files)
    files.select do |file|
      prefix = File.open(file) {|stream| stream.read(3)}
      prefix == "---"
    end
  end
end