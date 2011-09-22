var Slide = {
  currentNumber: function() {
    var number = window.location.hash.match(/\d+$/);
    
    if(number) {
      return parseInt(number[0]);
    } else {
      return undefined;
    }
  },
  
  executeJS: function(jsContainer) {
    eval(jsContainer.val());
  },
  
  hideDelayed: function() {
    var pendings = $(window.location.hash).find(
      '.delayed:visible:not(:animated):last'
    );

    if(pendings.length > 0) {
      return pendings.fadeOut(1000);
    } else {
      return false;
    }
  },
  
  limitNavigationQueue: [],

  next: function() {
    return (Slide.currentNumber() || 0) + 1;
  },

  prev: function() {
    return (Slide.currentNumber() || 0) - 1;
  },

  show: function(number, hideDelayed) {
    var slide = "#slide-" + number;
    
    if(hideDelayed) {
      $(slide).find('.delayed').hide();
    } else {
      $(slide).find('.delayed').show();
    }
    
    window.location.hash = slide;
    
    Slide.updateTitle();
  },
  
  showDelayed: function() {
    var pendings = $(window.location.hash).find(
      '.delayed:not(:visible):not(:animated):first'
    );

    if(pendings.length > 0) {
      return pendings.fadeIn(1000);
    } else {
      return false;
    }
  },
  
  showHtml: function(htmlContainer) {
    $.fancybox({'padding': 24, 'content': htmlContainer.val()});
  },
  
  toggleEdition: function(readonlyView, editableView) {
    if(editableView.is(':visible')) {
      editableView.hide();
      readonlyView.show();
      
      Slide.limitNavigationQueue.pop();
    } else {
      readonlyView.hide();
      editableView.show();
      
      Slide.limitNavigationQueue.push(1);
    }
  },
  
  updateTime: function() {
    var time = new Date().toLocaleTimeString().match(/^\d+:\d+/)[0];
    
    $('.slide footer time').text(time);
    
    window.setTimeout(Slide.updateTime, 5000);
  },
  
  updateTitle: function() {
    var number = Slide.currentNumber() || 0;
    var slide = "#slide-" + number;
    var title = $(slide).find('header h1').text();
    
    $('head title').text(title + ' (' + number + ')');
  }
};

jQuery(function($) {
  $('#ig_slides:has(form)').keydown(function(e) {
    // CTRL + ALT + s = save changes
    if($.inArray(e.which, [83, 115]) != -1 && e.ctrlKey && e.altKey) {
      $('#ig_slides form').submit();
      e.preventDefault();
    }
  });
  
  if($('.slide').length > 0) {
    if(!window.location.hash.match(/#/) && $('#slide-1').length > 0) {
      Slide.show('1', true);
    }

    $(document).keydown(function(e) {
      var key = e.which;
      var limitNavigation = Slide.limitNavigationQueue.length > 0;
      // 39 = right arrow, 34 = page down, 40 = down arrow, 13 = enter
      var nextKeys = limitNavigation ? [] : [39, 34, 40, 13];
      // 37 = left arrow, 33 = page up, 38 = up arrow, 8 = backspace
      var prevKeys = limitNavigation ? [] : [37, 33, 38, 8];

      if($.inArray(key, nextKeys) != -1) {
        var hasNext = $('#slide-' + Slide.next()).length > 0;

        if(!Slide.showDelayed() && hasNext) { Slide.show(Slide.next(), true); }

        e.preventDefault();
      } else if($.inArray(key, prevKeys) != -1) {
        var hasPrev = $('#slide-' + Slide.prev()).length > 0;

        if(!Slide.hideDelayed() && hasPrev) { Slide.show(Slide.prev(), false); }

        e.preventDefault();
      // CTRL + ALT + n = new slide
      } else if($.inArray(key, [78, 110]) != -1 && e.ctrlKey && e.altKey) {
        $('#slide-' + Slide.currentNumber()).find('.links a.new')[0].click();
        
        e.preventDefault();
      // CTRL + ALT + e = edit slide
      } else if($.inArray(key, [69, 101]) != -1 && e.ctrlKey && e.altKey) {
        $('#slide-' + Slide.currentNumber()).find('.links a.edit')[0].click();
        
        e.preventDefault();
      }
    });

    $('form.ruby_code').live('ajax:success', function(event, data) {
      $.fancybox({
        content: '<pre class="code">' + data + '</pre>',
        autoDimensions: false,
        width: 700,
        height: 500
      });
    });

    $('.delayed').hide();

    Slide.updateTime();

    Slide.updateTitle();
  }
});