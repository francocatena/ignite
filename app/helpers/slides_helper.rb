module SlidesHelper
  def show_options_for_code_node(form)
    langs = CodeNode::LANGS.map do |l|
      [t(l, :scope => [:view, :slides, :langs]), l]
    end
    
    form.select :lang, langs, :prompt => true
  end
  
  def draw_node_optionals(node)
    if node.kind_of?(CodeNode) && node.lang == 'ruby'
      readonly = "$('.CodeRay', $(this).parent('.node'))"
      editable = "$('.code_form', $(this).parent('.node'))"
      out = link_to_function(
        t(:'view.slides.switch_code_view'),
        "Slide.toggleEdition(#{readonly}, #{editable})",
        :class => :edit_code
      )
      
      out << render(
        :partial => 'slides/execute_ruby',
        :locals => { :node => node }
      )
      
      raw(out)
    end
  end
end