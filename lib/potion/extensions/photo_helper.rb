module Potion::Helpers
  def photo(identifier, attributes = {})
    raise "\n\nERROR: The 'photo' helper only works for posts.\n\n" unless self.is_a?(Potion::Post)
    
    extensions = [".jpg", ".jpeg", ".png", ".gif"]
    photos = @static_files.select {|file| extensions.include?(File.extname(file.path).downcase)}
    
    if identifier.is_a?(Integer)
      photo = photos.sort {|a,b| a.path <=> b.path }[identifier - 1]
    else
      candidates = photos.select{|photo| File.split(photo.path)[1].include?(identifier)}
      raise "\n\nERROR: '#{identifier}' could refer to more than one photo: #{candidates.map{|x|File.split(x.path)[1]}.inspect} in #{self.path}\n\n" unless candidates.length == 1
      photo = candidates.first
    end
    
    raise "\n\nERROR: No photo matching '#{identifier}' was found in: #{@path}\n\n" if photo.nil?
    attributes_string = ""
    attributes.each_pair {|k,v| attributes_string << "#{k}=\"#{v}\" "}
    "<img #{attributes_string} src=\"#{photo.relative_output_path}\"/>"
  end
end