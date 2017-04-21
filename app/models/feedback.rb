class Feedback < ApplicationRecord
  LOCALHOST = ['127.0.0.1', '::1']

  default_scope -> { order created_at: :asc }
  scope :remote, -> { where.not ip: LOCALHOST }
  scope :local, -> { where ip: LOCALHOST }

  # Callbacks
  before_destroy :check_if_can_be_destroyed

  # Validations
  validates :rate, presence: true, inclusion: { in: 1..5 }
  validates :ip, presence: true, uniqueness: { scope: :lesson_id }

  # Relations
  belongs_to :lesson

  def can_be_destroyed?
    LOCALHOST.include?(self.ip)
  end

  private

    def check_if_can_be_destroyed
      throw :abort unless can_be_destroyed?
    end
end
