class Slide < ApplicationRecord
  # Validations
  validates :title, :lesson, presence: true
  validates :title, :extra_classes, :style, length: { maximum: 255 }
  validates :number, presence: true
  validates :number, allow_nil: true, allow_blank: true,
    numericality: { greater_than: 0, only_integer: true }
  validates :number, allow_nil: true, allow_blank: true,
    uniqueness: { scope: :lesson_id }

  # Relations
  belongs_to :lesson, touch: true
  has_many :nodes, -> { order rank: :asc }, dependent: :destroy
  has_many :code_nodes, -> { order rank: :asc }
  has_many :text_nodes, -> { order rank: :asc }

  accepts_nested_attributes_for :nodes, allow_destroy: true

  def all_nodes
    (code_nodes | text_nodes).sort
  end

  def anchor
    "slide-#{number}"
  end
end
