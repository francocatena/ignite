module SlidesHelper
  def show_options_for_code_node(form)
    langs = CodeNode::LANGS.map do |l|
      [t(l, :scope => [:view, :slides, :langs]), l]
    end
    
    form.select :lang, langs, :prompt => true
  end
  
  def draw_node_optionals(node)
    if node.kind_of?(CodeNode)
      case node.lang
        when 'ruby'
          readonly = "$(this).parent('.node').find('.CodeRay')"
          editable = "$(this).parent('.node').find('.code_form')"
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
        when 'html'
          html_code = "$(this).parent('.node').find('.html_code')"
          out = link_to_function(
            t(:'view.slides.show_html'),
            "Slide.showHtml(#{html_code})",
            :class => :edit_code
          )
          
          out << content_tag(
            :textarea, raw(node.content), :class => 'html_code',
            :style => 'display: none;'
          )
          
          raw(out)
        when 'java_script'
          js_code = "$(this).parent('.node').find('.js_code')"
          out = link_to_function(
            t(:'view.slides.execute'),
            "Slide.executeJS(#{js_code})",
            :class => :edit_code
          )
          
          out << content_tag(
            :textarea, raw(node.content), :class => 'js_code',
            :style => 'display: none;'
          )
          
          raw(out)
      end
    end
  end
end