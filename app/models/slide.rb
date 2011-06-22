class Slide < ActiveRecord::Base
  # Validations
  validates :title, :length => { :maximum => 255 }, :presence => true
  validates :number, :presence => true
  validates :number, :allow_nil => true, :allow_blank => true,
    :numericality => { :greater_than => 0, :only_integer => true }
  
  # Relations
  has_many :nodes, :dependent => :destroy, :order => 'rank ASC'
  
  accepts_nested_attributes_for :nodes, :allow_destroy => true
end