class Node < ApplicationRecord
  include Comparable

  serialize :options, Hash

  # Validations
  validates :content, :rank, presence: true
  validates :rank, allow_nil: true, allow_blank: true,
    numericality: { greater_than: 0, only_integer: true }

  # Relations
  belongs_to :slide, touch: true

  def <=>(other)
    if other.kind_of?(Node)
      rank <=> other.rank
    else
      -1
    end
  end

  def ==(other)
    if other.kind_of?(Node)
      if new_record?
        object_id == other.object_id
      else
        id == other.id
      end
    end
  end

  def css_class
    self.options ||= {}

    options['css_class']
  end

  def css_class=(css_class)
    self.options ||= {}

    self.options['css_class'] = css_class if css_class.present?
  end

  def draw
    raise 'Must be implemented in the subclass!'
  end
end
