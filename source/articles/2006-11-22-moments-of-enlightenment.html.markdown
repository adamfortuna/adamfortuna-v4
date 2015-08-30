---
title: "Moments of Enlightenment"
permalink: moments-of-enlightenment
tags: Technical
---

I stand by that entry last month about [Choice Between Learning and Doing] . In October a lot of the Model-Glue code I wrote was in a vacuum after I got started. I saw the basic ways of doing things and for the most part went forward and did them. Two things I learned have much better ways of doing than I initially coded them, one of which directly affects what's in the svn repo for my little learning-model-glue project [Line Of Thought] right now.

The first I probably should have noticed when I mentioned actionpacks a few weeks ago but slipped my mind. The Coldspring XML for the email service that comes with Model Glue as a sample actionpack is a little snippet that looks like this (cut down to the unique features).

The second moment of clarity tonight came reading an old blog post by Joe Rinehart about [Dynamic sorting with modelglue.GenericList] . The generic database calls in ModelGlue are what power the scaffolding feature, so there's a heads up about how easy to work with they are. What I didn't know, however, was how easily they could be tied in with the ORM's gateway methods. Basically, in your ORM gateway methods you'll have custom queries for anything that might have a few joins and be a little more complicated than your average query. Unbeknownst to me, using the ModelGlue.GenericList (and other Generic\* methods I imagine) you can call on gateway methods and feed in URL parameters. This is basically like having the ability to call the query in your model when that's all you need before going to your view. Previously, I'd assumed you'd have to broadcast an event, make a method in a controller, call the newly created gateway method, add the record to the viewstate and then proceed- - so this method saves a decent amount of code. Tip of the hat to Rinehart.

  [Choice Between Learning and Doing]: /articles/choice-between-learning-and-doing/
  [Line Of Thought]: http://lineofthought.com
  [Dynamic sorting with modelglue.GenericList]: http://www.firemoss.com/blog/index.cfm?mode=entry&amp;entry=8D531C0E-3048-55C9-431EB0D750B46537
