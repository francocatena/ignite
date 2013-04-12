window.Slide =
  currentNumber: ->
    number = window.location.hash.match(/\d+$/)
    
    if number
      parseInt number[0]
    else
      undefined
  
  executeJS: (jsContainer) -> eval jsContainer.val()
  
  hideDelayed: ->
    restriction = '.delayed:visible:not(:animated):last'
    pendings = $(window.location.hash).find(restriction)

    if pendings.length > 0
      pendings.removeClass('current').fadeOut 500, ->
        $(window.location.hash).find(restriction).addClass('current')
    else
      false

  limitNavigationQueue: [],

  next: -> (Slide.currentNumber() || 0) + 1

  prev: -> (Slide.currentNumber() || 0) - 1

  show: (number, hideDelayed) ->
    slide = "#slide-#{number}"
    
    if hideDelayed
      $(slide).find('.delayed').hide()
    else
      $(slide).find('.delayed').show()
    
    window.location.hash = slide
    
    Slide.updateTitle()
  
  showDelayed: ->
    restriction = '.delayed:not(:visible):not(:animated):first'
    pendings = $(window.location.hash).find(restriction)

    if pendings.length > 0
      $(window.location.hash).find('.delayed').removeClass('current')

      pendings.addClass('current').fadeIn(500)
    else
      false
  
  showHtml: (htmlContainer) ->
    $('#modal-html .modal-body').html htmlContainer.val()
    $('#modal-html').modal 'show'
  
  toggleEdition: (readonlyView, editableView) ->
    if editableView.is(':visible')
      editableView.hide()
      readonlyView.show()
      
      Slide.limitNavigationQueue.pop()
    else
      readonlyView.hide()
      editableView.show()
      
      Slide.limitNavigationQueue.push(1)
  
  updateTime: ->
    time = new Date().toLocaleTimeString().match(/^\d+:\d+/)[0]
    
    $('.slide footer time').text(time)
    
    window.setTimeout(Slide.updateTime, 5000)
  
  updateTitle: ->
    number = Slide.currentNumber() || 0
    title = $("#slide-#{number}").find('.navbar .brand').text()
    
    $('head title').text "#{title} (#{number})"

jQuery ($) ->
  $('#ig_slides:has(form)').keydown (e) ->
    # CTRL + ALT + s = save changes
    if $.inArray(e.which, [83, 115]) != -1 && e.ctrlKey && e.altKey
      $('#ig_slides form').submit()
      e.preventDefault()
  
  if $('.slide').length > 0
    if !window.location.hash.match(/#/) && $('#slide-1').length > 0
      Slide.show('1', true)

    $(document).keydown (e) ->
      key = e.which
      limitNavigation = Slide.limitNavigationQueue.length > 0
      # 39 = right arrow, 34 = page down, 40 = down arrow, 13 = enter
      nextKeys = if limitNavigation then [] else [39, 34, 40, 13]
      # 37 = left arrow, 33 = page up, 38 = up arrow, 8 = backspace
      prevKeys = if limitNavigation then [] else [37, 33, 38, 8]

      if $.inArray(key, nextKeys) != -1
        hasNext = $("#slide-#{Slide.next()}").length > 0

        Slide.show Slide.next(), true if !Slide.showDelayed() && hasNext

        e.preventDefault()
      else if $.inArray(key, prevKeys) != -1
        hasPrev = $("#slide-#{Slide.prev()}").length > 0

        console.log "#slide-#{Slide.prev()}"

        Slide.show Slide.prev(), false if !Slide.hideDelayed() && hasPrev

        e.preventDefault()
      # CTRL + ALT + n = new slide
      else if $.inArray(key, [78, 110]) != -1 && e.ctrlKey && e.altKey
        $("#slide-#{Slide.currentNumber()}").find('a[data-action="new"]')[0].click()
        
        e.preventDefault()
      # CTRL + ALT + e = edit slide
      else if $.inArray(key, [69, 101]) != -1 && e.ctrlKey && e.altKey
        $("#slide-#{Slide.currentNumber()}").find('a[data-action="edit"]')[0].click()
        
        e.preventDefault()
      # F or f = Full screen mode
      else if $.inArray(key, [70, 102]) != -1 && !limitNavigation
        # Full screen request
        ((e) ->
          if e.requestFullScreen
            e.requestFullScreen()
          else if e.mozRequestFullScreen
            e.mozRequestFullScreen()
          else if e.webkitRequestFullScreen
            e.webkitRequestFullScreen()
        )(document.body)

    $(document).on 'ajax:success', 'form.ruby-code', (event, data) ->
      $('#modal-code .modal-body').html $('<pre></pre>').text(data)
      $('#modal-code').modal 'show'
    
    $(document).on 'click', 'a[data-toggle-edition]', (e) ->
      Slide.toggleEdition(
        $(this).parent('.node').find('.code-node'),
        $(this).parent('.node').find('.code-form')
      )

      e.preventDefault()
      e.stopPropagation()
    
    $(document).on 'click', 'a[data-show-html]', (e) ->
      Slide.showHtml $(this).parent('.node').find('.html-code')
      
      e.preventDefault()
      e.stopPropagation()
    
    $(document).on 'click', 'a[data-execute-js]', (e) ->
      Slide.executeJS $(this).parent('.node').find('.js-code')
      
      e.preventDefault()
      e.stopPropagation()

    $('.delayed').hide()

    Slide.updateTime()

    Slide.updateTitle()
