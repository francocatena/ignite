class Course < ApplicationRecord
  default_scope -> { order "#{table_name}.name ASC" }

  # Validations
  validates :name,
    presence: true,
    length: { maximum: 255 },
    uniqueness: { case_sensitive: false }

  # Relations
  has_many :lessons, -> { order sequence: :asc }, dependent: :destroy

  def to_s
    name
  end
end
