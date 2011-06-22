class Node < ActiveRecord::Base
  serialize :options, Hash
  
  # Validations
  validates :content, :rank, :presence => true
  validates :rank, :allow_nil => true, :allow_blank => true,
    :numericality => { :greater_than => 0, :only_integer => true }
  
  # Relations
  belongs_to :slide
  
  def draw
    raise 'Must be implemented in the subclass!'
  end
end