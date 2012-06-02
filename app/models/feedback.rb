class Feedback < ActiveRecord::Base
  attr_accessible :comments, :rate, :ip, :lesson_id
  
  default_scope order("#{table_name}.created_at ASC")
  
  # Callbacks
  before_destroy :avoid_destruction
  
  # Validations
  validates :rate, presence: true, inclusion: { in: 1..5 }
  validates :ip, presence: true, uniqueness: { scope: :lesson_id }
  
  # Relations
  belongs_to :lesson
  
  def avoid_destruction
    false
  end
end
