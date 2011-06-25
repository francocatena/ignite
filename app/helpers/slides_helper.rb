module SlidesHelper
  def show_options_for_code_node(form)
    langs = CodeNode::LANGS.map do |l|
      [t(l, :scope => [:view, :slides, :langs]), l]
    end
    
    form.select :lang, langs, :prompt => true
  end
  
  def draw_node_optionals(node)
    if node.kind_of?(CodeNode) && node.lang == 'ruby'
      out = link_to_function(
        t(:'view.slides.switch_code_view'),
        "$('.CodeRay', $(this).parent('.node')).toggle(); $('.code_form', $(this).parent('.node')).toggle();",
        :class => :edit_code
      )
      
      out << render(
        :partial => 'slides/execute_ruby',
        :locals => { :code => node.content }
      )
      
      raw(out)
    end
  end
end