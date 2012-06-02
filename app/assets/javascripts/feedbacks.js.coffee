jQuery ($)->
  if $('.feedback').length > 0
    $(document).on 'ajax:success', 'a.vote', (event, data)->
      $('.feedback').html(data)