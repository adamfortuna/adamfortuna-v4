function setupGallery(e) {
  e.preventDefault();

  var galleryElement = document.querySelectorAll('.pswp')[0];

  // build items array
  var photos = [],
      index,
      image,
      href = $(this).attr('href');
  $.each($('.gallery--photo'), function(i, a) {
    if($(a).attr('href') === href) {
      index = i;
    }

    image = $(a).find('img');
    var size = image.attr('data-size').split('x');

    var item = {
      src: $(a).attr('href'),
      title: $(image).attr('alt'),
      w: size[0],
      h: size[1],
      el: image
    };

    photos.push(item);
  });

  var options = {
    index: index,
    galleryUID: $('title').text().split(' - ')[0],
    barsSize: { top:0, bottom:0 },
    bgOpacity: 0.85,
    tapToClose: true,
    shareEl: false,
    fullscreenEl: false,
    tapToToggleControls: false,
    mainClass: 'pswp--minimal--dark'
  };

  // Initializes and opens PhotoSwipe
  var gallery = new PhotoSwipe(galleryElement,
    PhotoSwipeUI_Default, photos, options);
  gallery.init();
}
function gallery() {
  $('.gallery--photo, gallery--photo-image').on('click', setupGallery);
}
