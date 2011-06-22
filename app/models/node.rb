class Node < ActiveRecord::Base
  # Validations
  validates :content, :rank, :presence => true
  validates :rank, :allow_nil => true, :allow_blank => true,
    :numericality => { :greater_than => 0, :only_integer => true }
  
  # Relations
  belongs_to :slide
end