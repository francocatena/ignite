module SlidesHelper
  def show_options_for_code_node(form)
    langs = CodeNode::LANGS.map { |l| [t("view.slides.langs.#{l}"), l] }
    
    form.input :lang, label: false, collection: langs, prompt: true
  end
  
  def draw_node_optionals(node)
    if node.kind_of?(CodeNode)
      case node.lang
        when 'ruby'
          out = link_to(
            t('view.slides.switch_code_view'), '#',
            data: { 'toggle-edition' => true },
            class: [
              'edit-code', 'btn', 'btn-mini', 'btn-inverse', node.css_class
          ].compact.join(' ')
          )

          out << render(
            partial: 'slides/execute_ruby',
            locals: { node: node }
          )

          raw(out) if local?
        when 'html'
          out = link_to(
            t('view.slides.show_html'), '#',
            data: { 'show-html' => true },
            class: [
              'edit-code', 'btn', 'btn-mini', 'btn-inverse', node.css_class
          ].compact.join(' ')
          )
          content = content_tag(
            :div, raw(node.content), class: 'fancybox-in-slide'
          )
          
          out << content_tag(:textarea, raw(content), class: 'html-code hidden')
          
          raw(out)
        when 'java_script'
          out = link_to(
            t('view.slides.execute'), '#',
            data: { 'execute-js' => true },
            class: [
              'edit-code', 'btn', 'btn-mini', 'btn-inverse', node.css_class
          ].compact.join(' ')
          )
          
          out << content_tag(
            :textarea, raw(node.content), class: 'js-code hidden'
          )
          
          raw(out)
      end
    end
  end
end
