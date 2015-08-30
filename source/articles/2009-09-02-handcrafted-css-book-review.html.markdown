---
title: "Handcrafted CSS Book Review"
permalink: handcrafted-css-book-review
tags: Technical, Books, Review, Short
---

As a developer now a days, it's becoming more and more important to have a firm grasp on front-end development. The rise of Ajax has impacted more than just Javascript though- - the document object model has been a driving factor in how easy it is to work with an Ajax heavy page. Getting a handle on good DOM design and the use of the right HTML elements with CSS markup does more than just make the HTML look pretty — it makes your life MUCH easier when it comes to maintenance and Javascript integration. A few years ago, I read an amazing book that turned me on to this idea called [Bulletproof Web Design](http://adamfortuna.com/2006/10/26/bulletproof-web-design-book-review/) by [Dan Cederholm](http://simplebits.com/) . You can read my glowing review as a sign that it's a book I often recommend. _Handcrafted CSS_ is a the latest book by *Cederholm* , and runs a similar track. While _BulletProof_ is geared towards designers with some CSS experience, with the goal of refining their skills, *Handcrafted CSS* focuses on how to integrate CSS3/HTML 5 techniques into your existing skill set.

@pull left
![](/images/galleries/handcrafted-css.jpg!)
@

### Browsers Matter

One of the main questions the book asks is [Do Websites Need to Look Exactly the Same in Every Browser?](http://dowebsitesneedtolookexactlythesameineverybrowser.com/) (actually, that site is featured in the book). While previous design ideas concentrated on creating a look that was identical in every browser, *Cederholm* focuses a lot of attention on the idea of **progressive enhancement** . Instead of crafting every little detail the same in multiple browsers, certain details could be considered browser specific. Rounded corners are a prime example. They are an absolute **pain** to do cross browser, yet if you concentrate only on Firefox/Webkit/Opera you can round corners in a single line, or at most a few lines:

```css
.rounded {
  border: 1px solid #3792b3;
  border-radius: 4px;
  - webkit-border-radius: 4px;
  - moz-border-radius: 4px;
}
```

One thing you'll notice a lot throughout the book, is a focus on cross-browser support for CSS3. For instance, the `border-radius` attribute is not yet implemented by Firefox of Safari- the implement browser specific rules instead. So although the border-radius property won't be used by these right _ now_ , once these browsers support the final version of CSS3, you won't have to make any changes to your CSS. This futureproofing, and paying attention to flexibility is what Cederholm considers as craftsmanship; where the developer goes a step beyond the result and concentrates on longevity.

### What's this RGBA thing?

Although I'd heard about just about every concept in this book, it put a new spin on all of them. There was one addition, however, that I was completely unaware of- - RGBA. Defining colors using RGB has been possible for a good decade or so, but the A makes all the difference. RGBA (red, green, blue, alpha) defines the amount of red/green/blue (as integers from 0 to 255), as well as a transparency amount from 0-1. Much of what you can do with RGBA was available using the `opacity` CSS attribute, but some of the major differences are highlighted.

```css
h1 { color: rgb(55, 146, 179); }
h1 em { color: rgba(55, 146, 179, .8); font-size:80%; }
```

The first rule uses only rgb, generating a 100% opacity, normal font color. The inner &lt;em&gt; uses rgba for colors, specifying a .8 alpha amount. This creates a very pleasant affect where the emphasis text is a little bit lighter than the h1 text. As someone who get annoyed picking out tons of very similar font colors, being able to just lower the alpha transparency to create new colors is a huge time saver. It offers an additional bonus over setting opacity as well. Take for example a popup box on a page that you want to have a partial opacity- - like a lightbox. If you set the opacity of this box to something, say .25, then the box **and the text within the box** will both be partially transparent. Usually you'll just want the box itself to be like this. Using RGBA you can do exactly that — setting the background of the box to a a .25 alpha amount.

### Going a step Farther

These are some of the easiest to describe parts of the books, but it goes into many more ideas. Float management, fluid grid design and even adding the extra touch with some Javascript (jQuery is the language of choice) are all entire chapters. I grabbed the video version of the book as well, which I'm gad I did. It features just over an hour of Dan Cederholm talking about each of the 10 chapters from the book. For the most part it's all him talking — not reading from the book — but elaborating on some of the ideas. It occasionally shifts to the demo Tugboat side used in the book, with voice over description. If you read through the book completely you won't learn anything new from it, but it serves as a good reminder of what the major focuses of the book are distilled to 65 minutes.

### Who is this book for?

If you already have your head around CSS, and want to elevate your skills with some CSS3 spice, and focus on craftsmanship for current CSS ideals, this is a good one to checkout. What it's not is an encyclopedia of all that is CSS3. Not all chapters are on CSS3 either, although many of them mention solutions with IE6 incompatible of solutions. For these it usually gives an IE6 solution, using css hacks (rather than optional html includes for a special stylesheet). Even though it's not comprehensive, what it does cover, it handles very well. My only complain would be that it seemed a bit short. I finished it on a plane ride — and I'm not a fast reader. The full code from the book is available on the [official site](http://handcraftedcss.com/) , but only if you have the book. :) The Tugboat example used is very pretty though, and a lot can be learned from the source. If you see it a store, be sure to give it a once over and see if it's for you.
