module Potion::Helpers
  def gallery(*args)
    "GALLERY MOTHERFUCKER!! #{args.inspect}"
  end
  
  
end

class MoreCowbell
  def process(item)
    item.content = item.content + "\nMORE COWBELL"
  end
end

Potion::Site.register_extension(MoreCowbell)