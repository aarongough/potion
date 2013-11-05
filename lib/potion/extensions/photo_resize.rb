require 'mini_magick'

class PhotoResize
  def process(item)
    return unless item.path.include?("_posts")
    return if item.site.config["photo_resize"].nil?
    return unless item.site.config["photo_resize"]["enabled"]
    return if item.site.fast_build
    
    extensions = [".jpg", ".jpeg", ".gif", ".png"]    

    return unless extensions.include?(File.extname(item.output_path).downcase)
    image = MiniMagick::Image.read(item.content)
    image.resize(item.site.config["photo_resize"]["size"])
    item.content = image.to_blob
  end
end

Potion::Site.register_extension(PhotoResize)