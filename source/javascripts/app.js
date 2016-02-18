//= require modernizr/modernizr
//= require jquery/dist/jquery
//= require photoswipe/dist/photoswipe.js
//= require photoswipe/dist/photoswipe-ui-default.js
//= require_tree .

$(function() {
  $('body').addClass('is-loaded');

  if(!window.chrome) {
    $('.troll').hide();
  }
});

window.firstrun = true;
function troll() {
  if(speechSynthesis.onvoiceschanged && speechSynthesis.onvoiceschanged.name === 'sayAdam') {
    speechSynthesis.cancel()
    speechSynthesis.onvoiceschanged = null;
  } else {
    // paste in your console
    speechSynthesis.onvoiceschanged = function sayAdam() {
      var msg = new SpeechSynthesisUtterance();
      msg.voice = this.getVoices().filter(function(v) { return v.name == 'Cellos'; })[0];
      var content = document.getElementsByTagName('body')[0].textContent.replace(/^\n/mg, '').split(/\s\s/);
      if(content.length < 100) {
        content = content[0].split('\n')
      }
      content = content.join(' ').replace(/\.|\!|\,/mg, ' ').replace(/\s{2,}/mg, ' ').split(' ');
      var index = 0;
      for(var i=0, len=content.length; i<len; i++) {
        if(content[i] === 'Photos') {
          index = i;
          break;
        }
      }
      content = content.splice(i+1, content.length).join(' ');
      msg.text = content;
      this.speak(msg);
    };

    if(!window.firstrun) { speechSynthesis.onvoiceschanged(); }
    window.firstrun = false;
  }
}
