class Feedback < ActiveRecord::Base
  LOCALHOST = ['127.0.0.1', '::1']
  
  default_scope -> { order "#{table_name}.created_at ASC" }
  scope :remote, -> { where "#{table_name}.ip NOT IN (?)", LOCALHOST }
  scope :local, -> { where "#{table_name}.ip" => LOCALHOST }
  
  # Callbacks
  before_destroy :can_be_destroyed?
  
  # Validations
  validates :rate, presence: true, inclusion: { in: 1..5 }
  validates :ip, presence: true, uniqueness: { scope: :lesson_id }
  
  # Relations
  belongs_to :lesson
  
  def can_be_destroyed?
    LOCALHOST.include?(self.ip)
  end
end
