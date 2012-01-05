class Course < ActiveRecord::Base
  # Validations
  validates :name, presence: true, length: { maximum: 255 },
    uniqueness: { case_sensitive: false }
  
  # Relations
  has_many :lessons, dependent: :destroy, order: 'sequence ASC'
  
  def to_s
    self.name
  end
end