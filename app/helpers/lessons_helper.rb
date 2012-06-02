module LessonsHelper
  def has_not_voted?
    @feedback.nil?
  end
end