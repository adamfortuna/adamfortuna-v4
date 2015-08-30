---
title: "Flex and Yahoo Maps Integration"
permalink: flex-and-yahoo-maps-integration
tags: Technical, Flex
---

Why do extra work? When looking at what kind of APIs Yahoo maps offers for developers, I came across their [Flex API] and was absolutely stunned at how easy it might be to add them in. Unfortunately the current Flex API only supports up to Flex 1.5, which is completely different from Flex 2.0 (1.5 runs server side and has to be installed on the server, 2.0 compiles to swf files which run independently). i'll be keeping an eye on this for when they do release the Flex 2.0 version, as by then I might have advanced beyond the novice stage. The Flex 1.5 api allows for a very quick way of adding maps:

```html
<yahoo:YahooMap id="myMap" width="550"
  height="400" zoomLevel="3"
  latitude="37.77159" longitude="-122.401714" />
```

Along with some easy ways to add single points to the map. In searching for a way to implement maps now though, I came across a wonderful example on [inserting Yahoo! maps in a Flex 2 application] complete with a [working example][inserting Yahoo! maps in a Flex 2 application] . I have to say, it's developer support like this that make things fun when you're first getting started.

Admittedly, I've cheated with the maps integration up to this point by using this, but should be a good intro to how they work. Tomorrow I'll probably add some kind of feature to `clear` previously clicked on items from the map (probably whenever a new filter() occurs) as well as have a new option in the filter section to "map results" which would add all the filter results to the map, although I'll probably need some kind of a limit. What impresses me most about this is the speed at which the map reacts.

It's hard to compare it to Google Maps API for me though, because at the time I worked with Google I was just getting into Javascript and their API was only just released. It's no surprise that due to API changes the current script no longer works. Anyways, [ArcadeFly.com] is updated with mapping features, and you can have a good idea of what's coming next now too.

  [Flex API]: http://developer.yahoo.com/maps/flash/flexGettingStarted.html
  [inserting Yahoo! maps in a Flex 2 application]: http://www.asfusion.com/blog/entry/inserting-yahoo-maps-in-a-flex-2-application
  [ArcadeFly.com]: http://www.arcadefly.com
