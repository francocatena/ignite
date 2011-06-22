class Slide < ActiveRecord::Base
  # Validations
  validates :title, :length => { :maximum => 255 }, :presence => true
  validates :number, :presence => true
  validates :number, :allow_nil => true, :allow_blank => true,
    :numericality => { :greater_than => 0, :only_integer => true }
end