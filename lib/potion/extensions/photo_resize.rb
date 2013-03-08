require 'mini_magick'

class PhotoResize
  def process(item)
    return unless item.is_a?(Potion::Post)
    extensions = [".jpg", ".jpeg", ".gif", ".png"]    

    item.static_files.each do |file|
      next unless extensions.include?(File.extname(file.output_path))
      #image = MiniMagick::Image.new(file.output_path)
      #image.resize("20x20")
    end
  end
end

Potion::Site.register_extension(PhotoResize)