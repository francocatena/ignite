module LessonsHelper
  def has_not_voted?
    !!@feedback.try(:new_record?)
  end

  def link_to_lesson_feedback(lesson)
    size = lesson.feedbacks.size
    average = size > 0 ? '%.2f' % (lesson.feedbacks.sum('rate') / size.to_f) : '-'
    content = t(
      'view.lessons.feedback_resume.html', size: size, average: average
    )

    link_to(
      '&#xe029;'.html_safe, lesson_feedbacks_path(lesson),
      class: 'iconic', title: Feedback.model_name.human(count: 0),
      data: { show_popover: true, content: content}
    )
  end
end
