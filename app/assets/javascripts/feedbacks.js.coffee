jQuery ($)->
  if $('.feedback').length > 0
    $(document).on 'ajax:success', 'form#new_feedback', (event, data)->
      $('.feedback').html(data)
      
    $(document).on 'focus', '#feedback_comments', ->
      Slide.limitNavigationQueue.push(1)
      
    $(document).on 'blur', '#feedback_comments', ->
      Slide.limitNavigationQueue.pop()
