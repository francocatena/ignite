module SlidesHelper
  def show_options_for_code_node(form)
    langs = CodeNode::LANGS.map do |l|
      [t(l, :scope => [:view, :slides, :langs]), l]
    end
    
    form.select :lang, langs, :prompt => true
  end
end