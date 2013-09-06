class Node < ActiveRecord::Base
  include Comparable
  
  serialize :options, Hash
  
  # Validations
  validates :content, :rank, presence: true
  validates :rank, allow_nil: true, allow_blank: true,
    numericality: { greater_than: 0, only_integer: true }
  
  # Relations
  belongs_to :slide
  
  def <=>(other)
    if other.kind_of?(Node)
      self.rank <=> other.rank
    else
      -1
    end
  end
  
  def ==(other)
    if other.kind_of?(Node)
      if self.new_record?
        self.object_id == other.object_id
      else
        self.id == other.id
      end
    end
  end
  
  def css_class
    self.options ||= {}
    
    self.options['css_class']
  end
  
  def css_class=(css_class)
    self.options ||= {}
    
    self.options['css_class'] = css_class if css_class.present?
  end
  
  def draw
    raise 'Must be implemented in the subclass!'
  end
end
