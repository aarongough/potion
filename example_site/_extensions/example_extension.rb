require 'mini_magick'

module Potion::Helpers
  def gallery(*args)
    "GALLERY!! #{args.inspect}"
  end
  
  def christmas_annoyance(repeat = 0)
    output = ""
    repeat.times do
      output << "<p>Jingle, Jingle, Jingle bell rock<br />"
      output << "What a bright time<br />"
      output << "Jingle, Jingle, Jingle bell rock<br />"
      output << "It's the right time</p>"
    end
    
    output
  end
end

class TooCheapForInstagram
  def process(item)
    return unless item.is_a?(Potion::StaticFile)
    extensions = [".jpg", ".jpeg", ".gif", ".png"]    
    return unless extensions.include?(File.extname(item.output_path).downcase)
    
    image = MiniMagick::Image.read(item.content)
    image.sepia_tone("80%")
    image.vignette("10")
    item.content = image.to_blob
  end
end

class MoreCowbell
  def process(item)
    item.content = item.content + "\nMORE COWBELL"
  end
end


Potion::Site.register_extension(TooCheapForInstagram)
Potion::Site.register_extension(MoreCowbell)