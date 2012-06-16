module LessonsHelper
  def has_not_voted?
    @feedback.new_record?
  end
end