var Slide = {
  currentNumber: function() {
    var number = window.location.hash.match(/\d+$/);
    
    if(number) { return parseInt(number[0]); }
  },
  
  hideDelayed: function() {
    var pendings = $(
      '.delayed:visible:not(:animated):last',
      $(window.location.hash)
    );

    if(pendings.length > 0) { return pendings.fadeOut(1000); }
  },

  next: function() {
    return (Slide.currentNumber() || 0) + 1;
  },

  prev: function() {
    return (Slide.currentNumber() || 0) - 1;
  },

  show: function(number, hideDelayed) {
    var slide = "#slide-" + number;
    
    if(hideDelayed) {
      $('.delayed', $(slide)).hide();
    } else {
      $('.delayed', $(slide)).show();
    }
    
    window.location.hash = slide;
    
    Slide.updateTitle();
  },
  
  showDelayed: function() {
    var pendings = $(
      '.delayed:not(:visible):not(:animated):first',
      $(window.location.hash)
    );

    if(pendings.length > 0) { return pendings.fadeIn(1000); }
  },
  
  updateTime: function() {
    $('div.slide footer time').text(new Date().toLocaleTimeString());
    
    window.setTimeout(Slide.updateTime, 1000);
  },
  
  updateTitle: function() {
    var number = Slide.currentNumber() || 0;
    var slide = "#slide-" + number;
    var title = $('h1', $('header', $(slide))).text();
    
    $('head title').text(title + ' (' + number + ')');
  }
};

jQuery(function($) {
  if(!window.location.hash.match(/#/) && $('#slide-1').length > 0) {
    Slide.show('#slide-1', true);
  }

  $(document).keydown(function(e) {
    var key = e.which;
    // 39 = right arrow, 34 = page down, 40 = down arrow, 13 = enter
    var nextKeys = State.limitNavigation ? [] : [39, 34, 40, 13];
    // 37 = left arrow, 33 = page up, 38 = up arrow, 8 = backspace
    var prevKeys = State.limitNavigation ? [] : [37, 33, 38, 8];

    
    if($.inArray(key, nextKeys) != -1) {
      var hasNext = $('#slide-' + Slide.next()).length > 0;
      
      if(hasNext && !Slide.showDelayed()) { Slide.show(Slide.next(), true); }
      
      e.preventDefault();
    } else if($.inArray(key, prevKeys) != -1) {
      var hasPrev = $('#slide-' + Slide.prev()).length > 0;
      
      if(hasPrev && !Slide.hideDelayed()) { Slide.show(Slide.prev(), false); }
      
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
});