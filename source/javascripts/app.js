//= require modernizr/modernizr
//= require jquery/dist/jquery
//= require photoswipe/dist/photoswipe.js
//= require photoswipe/dist/photoswipe-ui-default.js
//= require_tree .

$(function() {
  $('body').addClass('is-loaded');
});

window.speaking = false;

function troll() {
  console.log(window.speaking);
  if(!window.speaking) {
    window.speaking = true;
    // paste in your console
    speechSynthesis.onvoiceschanged = function() {
      var msg = new SpeechSynthesisUtterance();
      msg.voice = this.getVoices().filter(v => v.name == 'Cellos')[0];
      content = document.getElementsByTagName('body')[0].textContent.replace(/^\n/mg, '').split('\n').splice(5, 100).join(' ').replace(/\.|\!|\,/mg, ' ')
      msg.text = content;
      this.speak(msg);
    };
  } else {
    window.speaking = false;
    speechSynthesis.pause();
  }
}
