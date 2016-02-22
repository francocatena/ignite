module LessonsHelper
  def has_not_voted?
    !!@feedback&.new_record?
  end

  def link_to_lesson_feedback(lesson)
    size = lesson.feedbacks.size
    average = size > 0 ? '%.2f' % (lesson.feedbacks.sum('rate') / size.to_f) : '-'
    content = t(
      'view.lessons.feedback_resume.html', size: size, average: average
    )
    options = {
      title: Feedback.model_name.human(count: 0), data: { content: content}
    }

    link_to lesson_feedbacks_path(lesson), options do
      content_tag :span, nil, class: 'glyphicon glyphicon-stats'
    end
  end
end
