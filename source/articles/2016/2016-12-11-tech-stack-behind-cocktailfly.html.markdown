---
title: Tech Stack Behind CocktailFly
date: 2016-12-11
tags: Technical
description: Why I used Rails 5, Bootstrap 4, jQuery and dependable favorites to create something new.
permalink: tech-stack-behind-cocktailfly
---

Like a lot of web developers, I register entirely too many domains with the hope that I'll eventually do something with them. In June 2015 (a year and half ago), I registered [CocktailFly.com](http://cocktailfly.com) without a great idea in mind.

Initially I was planning on using [Neo4j](https://neo4j.com/) to create a cocktail recipe site, with the idea of creating something where you could input your ingredients and get a list of cocktails you could create.

## Changing Ideas

The more I made cocktails at home though, the less interesting this idea became. Making things to recipe became less interesting than experimenting and the idea shifted to something else -- what if this became a listing site for places I like visiting in cities around the world?

When I travel to a new place, I'll always research a few different things -- good places for coffee, cocktails, grocery stores, restaurants -- amongst others. This would be a good place to put some of this research related to cocktails.

## Get to Coding

I've always liked how Google Maps shows a listing of search results. [Eater Maps](http://www.eater.com/maps/best-new-restaurants-st-louis) built on this idea and made it even better. I decided to try creating an interface similar to Eaters to see what it would involve.

## Tech Stack

Instead of trying to go all out on the latest and greatest, I tried seeing how *fast* I could create this idea and get it out into production. I haven't had a chance to program too much at Code School lately, so this was partially review to not lose touch.

Because of this I choose technologies I was most familiar with:

* Rails 5 w/Ruby 2.3
* ActiveAdmin
* Haml
* Sass
* Mini Magick (For uploading and resizing images)
* Bootstrap 4 (Alpha)
* jQuery
* Markdown

Aside from Bootstrap 4, everything on this list is at least 5 years old. I considered stretching my legs and using React or something else for the interface, but for a proof of concept that piece is relatively small. The entire JS (ES 5 even) for this project is 140 lines.

## Bootstrap 4

I'm a huuuge fan of Bootstrap (if writing a [Code School Course](https://www.codeschool.com/courses/blasting-off-with-bootstrap) wasn't a tipoff enough).

One part about Bootstrap 4 that I LOVE is that it was rewritten in Sass, so now you can include it straight in your sass project and set some variables! You can even include only the pieces of Bootstrap you want to use if you want a smaller footprint.

Bootstrap 4 brings a few really cool new features that make life a lot easier as well.

### Cards

[Cards](http://v4-alpha.getbootstrap.com/components/card/) are an great way to organize distinct pieces of content. Each location on the site is a card.

![Cards](/images/galleries/articles/launching-cocktailfly/cards.png)


### Tags are now Labels

Labels (formerly called Tags), are an easy indicator to use in categorization. The tricky thing is that the docs are out of date with the v4 branch -- so it's important to read the commit messages and code if you're working off the latest. "Tags" were changed "labels" due to some conflicts with Wordpress class names. Easy change to make if you know what to do.

![Tags](/images/galleries/articles/launching-cocktailfly/tags.png)

### Spacing for Margins and Padding

Another useful thing in Bootstrap 4 is the addition of [Spacing](http://v4-alpha.getbootstrap.com/utilities/spacing/) classes. Here's the formula for how these spacing classes work:

```
.{property}{sides}-{size}
```

*Propery*: *m* for margin, *p* for padding.
*Sides*: You can set a side -- *l*eft, *r*ight, *t*op, *b*ottom. Or *x*/*y* for top+bottom or left+right. Or even *a*ll.
*Size*: Is 0-3. This uses the `$spacer` variable and builds off that.

Using these means a lot less custom CSS to control positioning.

## ActiveAdmin

You'll know I started a Rails site because it has [ActiveAdmin](http://activeadmin.info/). It's so crazy easy to setup and lets you skip creating a bunch of forms (which are the most boring part of web development to me).

All data for the site is entered in through the admin. ActiveAdmin even makes it easy to create 1 to many associations with draggable ordering.

![ActiveAdmin](/images/galleries/articles/launching-cocktailfly/active_admin.png)

For this form, I didn't have to write a line of HTML, CSS, JavaScript - nor a Rails controller. All I needed to do was set my models up with the right `accepts_nested_attributes_for` settings and it all worked.

## jQuery and Google Maps

Years ago I create an Arcade Listing website that used Google Maps. For that one, I tried using wrapper libraries to create the Google Maps locations. I learned a lot in that experiment -- mainly that I'd rather just use the Google Maps API directly.

Creating the map, with an initial boundary, location markers, info windows for popups, and scrolling into view to match the cards was all less than 140 lines of code. It's just not enough to warrant learning a 3rd party library for managing. Even saying that, I did use a bunch of front-end libraries still:

* jQuery
* Bootstrap
* Lodash
* jQuery ScrollTo (for syncing the map and the cards)

![Maps](/images/galleries/articles/launching-cocktailfly/maps.png)


Removing all of these and doing it in straight JS wouldn't have been tough, but keeping these in made things go faster.

## Deployed in a Week

From initial commit to deploy to production ended up being around a week of nights and weekends.

![Commits](/images/galleries/articles/launching-cocktailfly/commits.png)

(removed the in between commits)

## Next Steps

So what's next for this? Marilyn and I have been talking about using this system for restaurants on [Forkful](http://forkful.net/) in order to incorporate best of lists in a really cool way. I'm excited to see where it goes next!
