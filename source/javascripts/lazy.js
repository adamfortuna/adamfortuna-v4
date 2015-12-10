$.fn.isOnScreen = function(){
    var win = $(window);
    var viewport = {
        top : win.scrollTop(),
        left : win.scrollLeft()
    };
    viewport.right = viewport.left + win.width();
    viewport.bottom = viewport.top + win.height();

    var bounds = this.offset();
    bounds.right = bounds.left + this.outerWidth();
    bounds.bottom = bounds.top + this.outerHeight();

    return (!(viewport.right < bounds.left || viewport.left > bounds.right || viewport.bottom < bounds.top || viewport.top > bounds.bottom));
};

function lazy() {
  $('.lazy img').unveil(2000, function() {
    $(this).load(function() {
      $(this).closest('.lazy').removeClass('lazy');
    });
  });

  $('.lazy video').unveil(200, function() {
    var video = $(this),
        videoEl = $(this)[0],
        options = JSON.parse(video.attr('data-lazy-setup'));

    videojs(videoEl, options, function(){
      debugger
      // Player (this) is initialized and ready.
    });

    // if(autoplay) {
    //   videoEl.play();
    //   checkForVideo = function() {
    //     if(!video.isOnScreen()) {
    //       videoEl.pause();
    //       clearInterval(videoInterval);
    //     }
    //   };
    //   var videoInterval = setInterval(checkForVideo, 1000);
    // }
  });
}
