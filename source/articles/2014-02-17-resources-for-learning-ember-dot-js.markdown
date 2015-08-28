---
title: Resources for Learning Ember.js
date: 2014-02-17 10:15
permalink: learning-emberjs
tags: Technical, JavaScript
---

About 6 months ago I started learning Ember.js. The first few months I was spent reading the [Ember.js Guides](http://emberjs.com/guides/) (which are amazing by the day), and going through every screencast I could find. We had some Ember projects at work, but the main reason for learning it was to overcome some of the limitations and code clutter that was starting to present itself in more advanced Backbone.js applications I'd worked on.

While the subject of learning Ember.js is still fresh my mind, I wanted to share what worked for me.

## Warming Up With Ember.js

@pull left
![Warming Up With Ember.js](/images/galleries/codeschool/ember.png){: .icon}
@

I'll start at the end. This isn't what I used to learn Ember.js, but it is the result of everything I learned. In December of 2013, Code School released [Warming Up With Ember.js](https://www.codeschool.com/courses/warming-up-with-emberjs), a course which teaches Ember.js from scratch. It features over 100 minutes of video, with about as much time also doing in browser challenges. It's the result of much research, discussion and incorporates feedback from many people to create what I think is the best way to get started using Ember.js. It's the resource I wanted going in.

I lucked into being able to write the content of the course, in that I got to immerse myself in the very lively and thriving Ember community. If you choose to go down the Ember.js path, I'm sure you'll understand what I'm talking about.


## Ember.js Main Site

@pull left
![Ember.js](/images/galleries/logos/ember.png){: .icon}
@

After downloading the library from the [Emberjs.com](http://emberjs.com/), reading over some of the examples on the homepage helps understand what you can do with Ember. It might be too complicated to understand if you're just getting started, but going through the guides will help that.

### Ember.js Guides

The Ember website has an amazing [Ember.js Guides](http://emberjs.com/guides/) page which has really taken shape in previous months. They walk through all of the main types of objects you'll encounter in an Ember.js application one by one. This is format that's extremely helpful when getting started and not overwhelming. We do this in the Code School Ember course as well, but the Guides have more space to go into increased detail on individual topics.

The only downside of the guides is that if you're getting started you might not know what you need to focus on from them. After trying out some of the concepts mentioned, I'd often return to the guides and then better understand the shape of the problem and solution.

## Screencasts

I'm a sucker for screencasts. I learned Ruby on Rails almost entirely by watching every single [Railscast](http://railscasts.com/) video -- once to watch and a second time implementing them. Seeking out high quality Ember.js screencasts proved a little more difficult though -- not because there weren't any, but because there weren't *many*.

### Pluralsite

Pluralsite (formerly Peepcode) has a pair of Ember.js videos which I watched early on when I was learning Ember.

@pull right
![Fire Up Ember.js](/images/galleries/articles/resources-for-learning-ember-dot-js/peepcode-emberjs-cover.png)
@

#### Fire Up Ember.js

In early 2013, the only long form Ember.js screencast I could find was the Peepcode, now Pluralsite video, [Fire Up Ember.js](http://pluralsight.com/training/courses/TableOfContents?courseName=fire-up-emberjs&highlight=). Geoffrey Grosenbach does an amazing example walking through the individual parts of Ember and going into nested routing, Ember Data and some user interaction. I learned a lot from this screencast, and would put it as the best screencast for learning Ember (well, besides the Code School course).

The downside is that it was released in January of 2013, before Ember 1.0 and Ember Data 1.0rc. There have been a good number of changes since this time, especially concerning Ember Data (ie, using `store` rather than `App.Model` everywhere). The bulk of the content holds up well, but if you're just getting into Ember, it'll be difficult to know which parts are out of date.

#### Play by Play: Yehuda Katz

The [Play by Play with Yehuda](http://pluralsight.com/training/courses/TableOfContents?courseName=play-by-play-yehuda-katz&highlight=yehuda-katz_play-by-play-yehuda-katz-m06*0#play-by-play-yehuda-katz-m06) is also a good one. He spends about an hour doing the Ruby on Rails side, then another hour on the Ember.js side. It doesn't cover learning Ember from scratch in the same way as Fire Up does, but it concentrates on solving a real world problem, and is worth watching if you have a Pluralsite subscription.

### Ember Casts

[Erik Bryn](https://twitter.com/ebryn) put up [Embercasts](http://www.embercasts.com/), which includes a handful of free Ember.js videos. The amount of content is rather small, but they're free and dive into some more advanced topics like authentication and building an autocomplete widget.

### Ember 101

[Ryan Florance](https://twitter.com/ryanflorence) released 8 great screencasts that start from scratch with Ember on [Ember 101](http://ember101.com/). These start with an introduction to Ember and progress from there. These were some of the best free screencasts I came across, and watched the first few multiple times.

### Tom Dales Talks

[Tom Dale](), one of the Ember core team members, has given a number of good talks on Ember as well. I'd suggest checking out [Ember.js and URLs](https://vimeo.com/77760308) from the EmberATX and AustinJS meetup as a good one. Ember has a huge focus on URLs, and Tom really drives this point home in his talk. For an even more fun talk, check out the [Tom Dale vs Rob Conery Cage Match; Ember JS vs Angular](https://vimeo.com/68215606). Although having a framework author go against a framework user might set Angular in poor light, it's still a funny and fun talk contrasting the frameworks.

## Books

I'm still a book reader when it comes to learning new frameworks, but as Ember hadn't yet hit 1.0 when I was learning it there weren't too many options available. There's a good list of all of the available Ember.js books on [EmberWatch](http://emberwatch.com/books.html).

### Heretical Guide To Ember JS

The [Heretical Guide to Ember JS](http://gilesbowkett.blogspot.co.uk/2013/06/heretical-guide-to-ember-js.html) is a solid book for understanding parts of Ember, especially if you're coming from a Rails background. It doesn't deal with the data layer, be Giles compares most of the concepts in Ember to their Rails counterparts. I think a lot of the concepts in the book are now covered in the Guides though.

### Ember.js in Action

@pull left
![Ember.js in Action](/images/galleries/articles/resources-for-learning-ember-dot-js/ember_in_action.jpg){: .icon}
@


The Manning book, [Ember.js in Action](http://www.manning.com/skeie/) (currently in beta), by Joachim Haagen Skeie proved a little too much for me. It's written more like a traditional textbook, introducing all of the parts of Ember up front. I wouldn't suggest picking this one up for learning Ember from scratch. It might be worth a look through after you have some experience under your belt, but
considering [this](/images/resources-for-learning-ember-dot-js/ember-internal-structure.png) is the first graphic in the book, you might be struggling from the start. The book is still in beta, so some of this might change before it reaches production.


## Other Resources

[Emberwatch](http://emberwatch.com/) is probably *the* place to look for new Ember resources. This post is what ones I used, but many of them were discovered thanks to EmberWatch.

If you're a fan of podcasts, [The Ember Hotseat](http://emberhotseat.com/) by [DeVaris Brown](https://twitter.com/devarispbrown) is worth checking out. He has interviews with each member of the core team and other people in the Ember community.

### Twitter Follows

If you're wanting to emerse yourself in Ember, here's a few people you should follow:

* [emberjs](https://twitter.com/emberjs) - Official Twitter Account for Ember.js
* [Yehuda Katz](https://twitter.com/wycats) - Core team member, and Ember creator.
* [Tom Dale](https://twitter.com/tomdale) - Ember Core team member and pun creator.
* [Trek Glowacki](https://twitter.com/trek) - Core team member
* [Peter Wagenet](https://twitter.com/wagenet) - Core team member
* [Leah Silber](https://twitter.com/wifelette) - Core team member
* [Stefan Penner](https://twitter.com/stefanpenner) - Core team member
* [Alex Matchneer](https://twitter.com/machty) - Core team member
* [Kristofor Selden](https://twitter.com/krisselden) - Core team member
* [Ryan Florance](https://twitter.com/ryanflorence) - JavaScript and Ember Developer
* [Luke Melia](https://twitter.com/lukemelia) - Founder of Yapp, and runner of the (very large) NY Ember Meetup
* [DeVaris Brown](https://twitter.com/devarispbrown) - Ember Hotseat Host

## Building a Project

Like just about any subject, it's good to have an idea in mind of something you want to actually build. For me, it was [Warming Up With Ember.js](https://www.codeschool.com/courses/warming-up-with-emberjs), but also a [Read List page](http://adamfortuna.com/books/) for my personal blog. Good luck learning Ember.js!
