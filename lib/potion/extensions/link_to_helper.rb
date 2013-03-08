module Potion::Helpers
  def link_to(arg1, arg2 = nil, &block)
    raise "link_to requires either an item and a block, or a content string and an item" if arg2.nil? && block.nil?
    
    if block
      content = block.call
      item = arg1
    else
      content = arg1
      item = arg2
    end
    
    "<a href=\"#{item.relative_output_path}\">#{content}</a>"
  end
end