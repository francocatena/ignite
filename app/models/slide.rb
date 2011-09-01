class Slide < ActiveRecord::Base
  # Validations
  validates :title, :lesson, length: { maximum: 255 }, presence: true
  validates :number, presence: true
  validates :number, allow_nil: true, allow_blank: true,
    numericality: { greater_than: 0, only_integer: true }
  validates :number, allow_nil: true, allow_blank: true,
    uniqueness: { scope: :lesson_id }
  
  # Relations
  belongs_to :lesson
  has_many :nodes, dependent: :destroy, order: 'rank ASC'
  has_many :code_nodes, readonly: true, order: 'rank ASC'
  has_many :text_nodes, readonly: true, order: 'rank ASC'
  
  accepts_nested_attributes_for :nodes, allow_destroy: true
  
  def all_nodes
    (self.code_nodes | self.text_nodes).sort
  end
  
  def anchor
    "slide-#{self.number}"
  end
end