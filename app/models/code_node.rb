class CodeNode < Node
  # Supported languages
  LANGS = ['ruby', 'css', 'html', 'rhtml', 'java_script', 'yaml', 'sql', 'plaintext']

  validates_each :options do |record, attr, value|
    record.errors.add :lang, :invalid unless LANGS.include?(value['lang'].to_s)
  end

  def draw
    div_options = {
      line_numbers: :table, line_number_anchors: false, css: :class, hint: :info
    }
    marked_code = CodeRay.scan(self.content, self.lang).div(div_options)
    classes = ['code-node', self.css_class].compact.join(' ')

    "<div class=\"#{classes}\">#{marked_code}</div>".html_safe
  end

  def lang
    self.options ||= {}

    options['lang']
  end

  def lang=(lang)
    self.options ||= {}

    self.options['lang'] = lang
  end
end
