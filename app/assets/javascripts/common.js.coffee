window.State =
  newIdCounter: 0

window.EventHandler =
  addNestedItem: (e) ->
    template = eval(e.data('template'))

    $(e.data('container')).append(Util.replaceIds(template, /NEW_RECORD/g))

    e.trigger('item:added', e)
  hideItem: (e) ->
    Helper.hide($(e).parents($(e).data('target')))

    $(e).prev('input[type=hidden].destroy').val('1')

    $(e).trigger('item:hidden', $(e))
  removeItem: (e) ->
    target = e.parents(e.data('target'))

    Helper.remove(target)

    target.trigger('item:removed', target)

window.Helper =
  hide: (element, callback) ->
    $(element).stop().slideUp(500, callback)

  remove: (element, callback) ->
    $(element).stop().slideUp 500, ->
      $(this).remove()

      callback() if jQuery.isFunction(callback)

  show: (element, callback) ->
    e = $(element)

    e.stop().slideDown(500, callback) if e.is(':visible').length != 0

window.Util =
  merge: (hashOne, hashTwo) -> jQuery.extend({}, hashOne, hashTwo)

  replaceIds: (s, regex) ->
    s.replace(regex, new Date().getTime() + State.newIdCounter++)

  refreshSortNumbers: -> $('input.sort_number').val((i) -> i + 1)

jQuery ($) ->
  $('[data-show-tooltip]').tooltip()
  $('[data-show-popover]').popover(html: true, trigger: 'hover')

  eventList = $.map EventHandler, (v, k) -> k

  $(document).on 'click', 'a[data-event]', (event) ->
    return if event.stopped

    element = $(this)
    eventName = element.data('event')

    if $.inArray(eventName, eventList) != -1
      EventHandler[eventName](element)

      event.preventDefault()
      event.stopPropagation()

  $(document).on 'click', 'a[data-increase-font-size]', (event) ->
    return if event.stopped

    $($(this).data('target')).css
      zoom: (index, value) -> parseFloat(value) * 1.1

    event.preventDefault()
    event.stopPropagation()

  $(document).on 'click', 'a[data-decrease-font-size]', (event) ->
    $($(this).data('target')).css
      zoom: (index, value) -> parseFloat(value) / 1.1

    event.preventDefault()
    event.stopPropagation()
 HTMLAnchorElement.prototype.click = ->
    ev = document.createEvent('MouseEvents')
    ev.initEvent 'click', true, true

    document.location.href = this.href if this.dispatchEvent(ev) != false
