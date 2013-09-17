class Slide < ActiveRecord::Base
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
  has_many :nodes, -> { order 'rank ASC' }, dependent: :destroy
  has_many :code_nodes, -> { order 'rank ASC' }
  has_many :text_nodes, -> { order 'rank ASC' }
  
  accepts_nested_attributes_for :nodes, allow_destroy: true
  
  def all_nodes
    (code_nodes | text_nodes).sort
  end
  
  def anchor
    "slide-#{self.number}"
  end
end
