module Potion::Helpers
  def category(name)
    posts = @site.posts.select do |post|
      post.relative_output_path.split("/").select {|chunk| chunk != ""}[0] == name
    end
    
    posts.sort {|a,b| a.relative_output_path <=> b.relative_output_path }
  end
end