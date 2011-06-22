class CodeNode < Node
  # Supported languages
  LANGS = ['ruby', 'css', 'html', 'java_scrip']
  
  validates_each :options do |record, attr, value|
    record.errors.add attr, :invalid unless LANGS.include?(value['lang'].to_s)
  end
  
  def draw
    div_options = { :line_numbers => :table, :css => :class }
    
    CodeRay.scan(self.content, self.options['lang']).div(div_options).html_safe
  end
end