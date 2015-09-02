function lazy() {
  $('.lazy img').unveil(2000, function() {
    $(this).load(function() {
      $(this).closest('.lazy').removeClass('lazy');
    });
  });
}
