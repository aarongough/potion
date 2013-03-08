require 'mini_magick'

class PhotoResize
  def process(item)
    return unless item.is_a?(Potion::Post)
    extensions = [".jpg", ".jpeg", ".gif", ".png"]    

    item.static_files.each do |file|
      next unless extensions.include?(File.extname(file.output_path).downcase)
      image = MiniMagick::Image.read(file.content)
      image.resize("200x200")
      file.content = image.to_blob
    end
  end
end

Potion::Site.register_extension(PhotoResize)