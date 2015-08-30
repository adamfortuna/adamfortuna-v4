---
title: "Resize a Crossdomain"
permalink: resize-a-crossdomain-iframe
tags: Technical, JavaScript
---

When it comes to crossdomain quirks with frames and Ajax, there’s not usually a “good” solution — there’s just one that works. Something I was working on the other week had a “well it works” moment, although the solution was far from ideal.

### The Problem

The page in question is the [Sponsored These Tweeters](http://sponsoredtweets.com/tweeters/sponsor-these-tweeters/) page at SponsoredTweets. It’s a pretty basic Wordpress page with an iFrame that contains the list of Tweeters. Real easy way of adding a dynamic touch to a Wordpress site. The issue is that the iframe contains a dynamic amount of content, and could potentially grow or shrink based on the length of amount of tweeters being shown. The kicker? The page with the list of tweeters is at a subdomain, and under https.

### Monitoring with Jquery

My first idea with anything like this is “Can I just listen for a jquery event on the element?”. Well, sure, but the height of the iframe won’t change. You’ll only be able to get the height/width of the iframe itself, not the content within it from the page itself, so watching for a resize or load event on the iframe won’t work. What you’re really wanting to listen for is a change in the height of the content **Works?** No.

### Reaching into the frame with contentWindow

If your frame and the page containing it both exist on the same domain, you can reach into DOM of the frame and get the height that way. At anytime you can do something like this to get the height of the page:

```javascript
document
  .getElementById("iframeid")
  .contentWindow
  .document
  .body
  .scrollHeight
```

This bit of code will return an integer- - the height of the content of the frame in pixels. Even if the iframe has a height of (for example) 300px, the content itself could be smaller or larger. Unfortunately you can’t set a jQuery event watcher on `document.getElementById("iframeid").contentWindow.document.body` either (at least from what I’ve seen), so I can’t see a way to watch for a change in height. The “not-so-nice” fix for this is to make a really fast function that repeatedly checks a change in the height, and resizes the iframe accordingly. Here’s some sample code for this using jQuery.

```javascript
var $iframe = $("#iframeid");
function resize_iframe() {
  var current_height = $iframe.css("height");
  if(current_height != $iframe[0].contentWindow.document.body.scrollHeight) {
    $iframe.css("height", $iframe[0].contentWindow.document.body.scrollHeight);
  }
}
setInterval("resize_iframe();", 100);
```

Everytime I use `setTimeout()` or `setInterval()` in Javascript, it’s immediately a red flag. These (along with the evil- `eval` ) can be an obvious code smell, but also a trigger that the code itself isn’t designed in the best way. The problem with this though is that it won’t quite be realtime. Also the `contentWindow.document` object is not available cross-domain. Even doing things like `contentWindow.document.location.href` to get the current location of the frame doesn’t work if the calling page and the frame are on different domains/subdomains. This might work for some cases, but not if your iframe is on a different domain. **Works?** Yes. **Works on the same domain?** Yes. **Works on different subdomains on the same domain?** No.

### The document.domain hack

If both your frame and your calling page exist on the same parent domain, there’s a little hack you can do to get this to work. Each page has a `document.domain` variable that contains the domain from which ajax calls can be made to. If you rails application is up at <https://app.sponsoredtweets.com> , then your document domain will be set to **app.sponsoredtweets.com** . Of course your main website sitting at <http://sponsoredtweets.com> will have a document.domain ot **sponsoredtweets.com** . Because of this they won’t be able to talk to each other. What you can do is manually change the `document.domain` value. Surprisingly enough, you can tweak this value as long as you only get broader in your domain. For instance, if document.domain is \_ app.sponsoredtweets.com\_ , then you’ll be able to manually set this using something like this: `document.domain = "sponsoredtweets.com"` From that point on, that page will be treated as those requests were coming/going to that domain. Using this, you could set your iframe and the page containing the iframe to be on the same root domain, then reach into it’s contentHeight as described above. After you’ve set this to “sponsoredtweets.com” though, you won’t be able to change it again, as that’s the most general a `document.domain` can get. **Works on the same domain?** Yep. **Works on different subdomains on the same domain?** Yes. **Works crossdomain?** No. **Works across https?** No.

### Frame within a Frame within a Frame

Unfortunately, none of this works across domain, of from http connections to https. Here’s how it works for SponsoredTweets: The main page is **[http://sponsoredtweets.com/tweeters/sponsor-these-tweeters/](http://sponsoredtweets.com/tweeters/sponsor-these-tweeters/*), aka, the parent page. Which has a frame to** <https://app.sponsoredtweets.com/tweeters> \* , aka, the content page. Which has a frame to \* <http://sponsoredtweets.com/iframe.html> \* , aka, the placeholder page. The middle frame is the one that will change in height of course. For the same reasons as above, the middle frame cannot reach into it’s parent frame and call methods there either. It can, however, control it’s own iframe in a very limited sense. For instance, take this line from the

```javascript
$("#parent_domain")[0].contentWindow.location = 'http://sponsoredtweets.com/iframe.html#' + height;
```

Whenever the height of the content page changes, it updates the location of it’s frame to include a hash tag followed by the current height of the content. By itself this won’t do anything, but if that iframe.html page is watching for changes to it’s location, we can start from there. The placeholder page is what makes this all possible. All it has to do is monitor for changes to it’s hash, and when it sees them, send them up to the parent page (that is, the top level page). Now, although the content page can’t talk to it’s parent page, the placeholder page can talk to it since they are both on the same domain. Is it a hack? Oh yeah, and of the worst kind.
