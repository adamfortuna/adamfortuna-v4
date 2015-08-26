---
title: Designing eval everything
description: Using Octopress, Sass, MVCSS with the help of Code School courses to design eval everything.
date: 2013-09-06 01:11
tags: Technical, Design
permalink: designing-eval-everything
---

I'm not a designer. My last attempt at design was my [personal blog][] ([screenshot for posterity][]), which is far from a masterpiece. When starting this blog, I decided it was time to put some of what I've learned from the design talent at [Code School][] to use and see if my eye had improved.

## Octopress

First step was going with [Octopress][] and by extension [Jekyll][]. My last blog was on Jekyll, and I was always a little jealous of how easily it looked to get started with Octopress. The default theme also has Sass and Compass integration right away, which helps in getting started.

Rather than starting from the default theme and making tweaks, I everything away and started writing the HTML and Sass from scratch, which is something Octopress makes incredibly easy.


{% pullside left %}
![Assembling Sass](/images/posts/designing-eval-everything/sass.png){: .icon}
{% endpullside %}

## Sass

Sass is the language of choice for the designers at Code School. Specifically the sass style syntax, not the scss style. Code School and each course we do uses Sass, which has slowly built up my confidence in the subject.

I dug into the Ruby Sass gem to help build out the technical side of our Sass course, [Assembling Sass][], but it wasn't until I went through it and [Assembling Sass Part 2][] that I started to feel like some of the gaps in my knowledge were filled in.

## MVCSS

[Nick Walsh][] and [Drew Barontini][] put together [MVCSS][] which we use on all projects through [Envy Labs][] and Code School. Here's how they describe MVCSS:

{% blockquote MVCSS http://mvcss.github.io/ %}
MVCSS is a Sass-based CSS architecture for creating predictable and maintainable application style.
{% endblockquote %}

MVCSS is less of framework that you use, and more of a way of organizing your files and markup in a predictable manner. Although I'm not following all of the guidelines, the ones I am following do make things easier to maintain.

{% pullside left %}
![Fundamentals of Design](/images/posts/designing-eval-everything/design.png){: .icon}
{% endpullside %}

## Fundamentals of Design

In early August, Code School released a very different type of course called [Fundamentals of Design][] taught by [Tim Dikun][]. This course hammers in 3 specific topics: typography, color and layout. Like most developers (and most people), I can view a design and have a reaction that it's good or off somehow. Usually though, I have no idea why it is off, or what I could do to improve it. That's where this course fit in -- providing a bit of background on the topic.

{% pullside right %}
This site uses the [Droid Sans](http://www.google.com/fonts/specimen/Droid+Sans) font.
{% endpullside %}

For instance, I've never put much effort into choosing fonts. After going through this course I had a bit more confidence in choosing a font that might better match the content. I settled on [Droid Sans], one of the fonts mentioned in the course, and available for free on Google Fonts. It is apparently a **Humanist Sans Serif** font, which according to the course, is great for government or educational applications (I'll try to stay educational).

## Ruby

{% pullside right %}
Want to see how these little pullouts are done? [View the plugin](https://github.com/adamfortuna/evaleverything.com/blob/source/plugins/pullside.rb).
{% endpullside %}

It's not design, but a little ruby goes a long ways to filling in the gaps. It's dead simple to write plugins that will tie into the Markdown templating to add a bit of style if needed, like with the side pullouts used here. There are a bunch of others bundled with Octopress that are all basic Ruby and easy to understand if you want to see how something is formed.

If you need additional power, you can also drop in any other gem. If you need to debug something, you can always slip a `binding.pry` in and experiment to get the output you desire.

## Twitter Bootstrap

It's hard to mention Twitter Bootstrap to designers and not get an instant groan of pain. I imagine to some of them it's similar to starting up a Rails application using scaffolding, but putting it into production. That being said, it did help me get this site off the ground with some intelligent defaults in place.

For the most part, Bootstrap is used only for the layout at this point. Ideally I'll strip it out some time in the future, but until then it's been an amazing tool to help me get started.


## Write Your First 3 Posts

{% pullside left %}
Things like this will standout if you design around your content.
{% endpullside %}

For me it was impossible to know everything I needed from a design standpoint until writing a few posts. I started out with some sample filler text, but quickly realized it was missing a number of features.

After writing these first three posts, each day I'd look at it with a new eye and pick out what I saw as the part that needed the most work. Usually I didn't know what I could do at a glance, so it was a matter of experimenting with color, position and typography until it looked right.

## Logo

The logo at the time of this writing is only a placeholder until getting something else in there. At first glance it's a little too similar to the Internet Explorer icon for my liking.

## Responsive Design

One of the advantages of using Twitter Bootstrap is the build in responsive design functionality. A lot of this will _just work_ so long as you follow the grid conventions. This is easier said than done -- especially when a number of elements aren't controlled through Bootstrap. Making the footer responsive was as easy as adding a few `col-md-3`, `col-xs-12` and `col-sm-4` classes to various sections.

MVCSS has a super-simple `+respond-to` mixin that helps in controlling these too. For instance, at lower resolutions, the side panels are no longer shown.

```sass
+respond-to(993px, max-width)
  .pull-left,
  .pull-right
    float: none !important
```

This will create the `@media` query needed for this setup. I'm sure as I rip out Bootstrap and try to recreate parts on my own, I'll be using this much more.


[personal blog]:http://blog.adamfortuna.com/
[screenshot for posterity]:/images/posts/designing-eval-everything/blog-adamfortuna-com.png
[Code School]:http://codeschool.com
[Octopress]: http://octopress.org/
[Jekyll]:http://github.com/mojombo/jekyll
[Assembling Sass]: http://www.codeschool.com/courses/assembling-sass
[Assembling Sass Part 2]: http://www.codeschool.com/courses/assembling-sass-part-2
[MVCSS]: http://mvcss.github.io/
[Nick Walsh]: http://nick-walsh.com/
[Drew Barontini]: http://drewbarontini.com/
[Envy Labs]: http://envylabs.com/
[View the plugin]: https://github.com/adamfortuna/evaleverything.com/blob/source/plugins/pullside.rb
[Fundamentals of Design]: http://www.codeschool.com/courses/fundamentals-of-design
[Tim Dikun]: http://timdikun.com
[Droid Sans]: http://www.google.com/fonts/specimen/Droid+Sans
