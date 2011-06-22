class TextNode < Node
  def draw
    textilized = RedCloth.new(self.content, [:hard_breaks])
    
    textilized.hard_breaks = true if textilized.respond_to?(:'hard_breaks=')
    
    textilized.to_html.html_safe
  end
end