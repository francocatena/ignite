class CodeNode < Node
  # Supported languages
  LANGS = ['ruby', 'css', 'html', 'java_script', 'yaml', 'sql', 'plaintext']
  
  validates_each :options do |record, attr, value|
    record.errors.add attr, :invalid unless LANGS.include?(value['lang'].to_s)
  end
  
  def draw
    div_options = { :line_numbers => :table, :css => :class }
    marked_code = CodeRay.scan(self.content, self.lang).div(div_options)
    
    "<div class=\"code_node\">#{marked_code}</div>".html_safe
  end
  
  def lang
    self.options ||= {}
    
    self.options['lang']
  end
  
  def lang=(lang)
    self.options ||= {}
    
    self.options['lang'] = lang
  end
end