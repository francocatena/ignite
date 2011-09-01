var State = {
  newIdCounter: 0
}

var EventHandler = {
  addNestedItem: function(e) {
    var template = eval(e.data('template'));

    $(e.data('container')).append(Util.replaceIds(template, /NEW_RECORD/g));

    e.trigger('item:added', e);
  },
  
  hideItem: function(e) {
    Helper.hide($(e).parents($(e).data('target')));

    $(e).prev('input[type=hidden].destroy').val('1');

    $(e).trigger('item:hidden', $(e));
  },

  removeItem: function(e) {
    var target = e.parents(e.data('target'));

    Helper.remove(target);

    target.trigger('item:removed', target);
  }
}

var Helper = {
  hide: function(element, callback) {
    $(element).stop().slideUp(500, callback);
  },

  remove: function(element, callback) {
    $(element).stop().slideUp(500, function() {
      $(this).remove();
      
      if(jQuery.isFunction(callback)) {callback();}
    });
  },

  show: function(element, callback) {
    var e = $(element);

    if(e.is(':visible').length != 0) {
      e.stop().slideDown(500, callback);
    }
  }
}

var Util = {
  merge: function(hashOne, hashTwo) {
    return jQuery.extend({}, hashOne, hashTwo);
  },

  replaceIds: function(s, regex){
    return s.replace(regex, new Date().getTime() + State.newIdCounter++);
  },
  
  refreshSortNumbers: function() {
    $('input.sort_number').val(function(i) {return i + 1;});
  }
}

jQuery(function($) {
  var eventList = $.map(EventHandler, function(v, k ) {return k;});
  
  // For old browsers without HTML5 support
  //$('*[autofocus]:visible:first').focus();
  
  $('a[data-event]').live('click', function(event) {
    if (event.stopped) return;
    var element = $(this);
    var eventName = element.data('event');

    if($.inArray(eventName, eventList) != -1) {
      EventHandler[eventName](element);
      
      event.preventDefault();
      event.stopPropagation();
    }
  });
  
  $('a.increase_font_size').live('click', function(event) {
    if (event.stopped) return;
    $($(this).data('target')).css({
      fontSize: function(index, value) { return parseFloat(value) * 1.1 }
    });
    
    event.preventDefault();
    event.stopPropagation();
  });
  
  $('a.decrease_font_size').live('click', function(event) {
    $($(this).data('target')).css({
      fontSize: function(index, value) { return parseFloat(value) / 1.1 }
    });
    
    event.preventDefault();
    event.stopPropagation();
  });
  
  $('#loading_image').bind({
    ajaxStart: function() {$(this).show();},
    ajaxStop: function() {$(this).hide();}
  });

  $('form').submit(function() {
    $(this).find('input[type="submit"], input[name="utf8"]').attr(
      'disabled', true
    );
  });
});
