class Lesson < ActiveRecord::Base
  default_scope -> { order sequence: :asc }

  # Validations
  validates :name, length: { maximum: 255 }, presence: true
  validates :course, presence: true
  validates :sequence, presence: true
  validates :sequence, allow_nil: true, allow_blank: true,
    numericality: { greater_than: 0, only_integer: true }

  # Relations
  belongs_to :course
  has_many :slides, -> { order number: :asc }, dependent: :destroy
  has_many :feedbacks

  def to_s
    name
  end
end
