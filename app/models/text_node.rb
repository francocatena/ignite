class TextNode < Node
  def draw
    classes = ['text_node', css_class].compact.join(' ')
    textilized = RedCloth.new(content, [:hard_breaks])

    textilized.hard_breaks = true if textilized.respond_to?(:'hard_breaks=')

    if textilized[0..2] == '<p>' then textiled = textiled[3..-1] end
    if textilized[-4..-1] == '</p>' then textiled = textiled[0..-5] end

    "<div class=\"#{classes}\">#{textilized.to_html}</div>".html_safe
  end
end
