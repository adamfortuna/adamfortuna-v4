---
title: Teaching iOS 7 at Code School
date: 2013-10-04 14:03
permalink: teaching-ios7-at-codeschool
tags: Technical, Code School
---

A long time ago, at a [WWDC](http://adamfortuna.com/wwdc/) far away, 3 travelers from [Code School][] journeyed to Apple Mecca in search of new technologies. The goal was to see what was new in iOS 7, while looking for ways to best teach this new addition to the iOS world.

This week we released the result of that experience.

## Think Outside the Browser

Up to this point, every Code School course has used an in browser editor. This simple interaction makes sense for learning a new topic from scratch. You don't need to install anything on your local system, and you can see what it's like to develop in a sandbox. After you've learned the ropes, you want a taste of programming in the real world. [Eric Allam](https://twitter.com/eallam) thought there could be a better way to pull this off.

@pull left
![Core iOS 7](http://localhost:4000/galleries/codeschool/core-ios-7.png)
@

[Core iOS 7](http://ios7.codeschool.com) goes a different path. After watching a video on a topic, you'll be prompted to download a zip file. Unzip this file and you'll have an entire Xcode project, with a unique identifier in it that Code School uses to identify you. In this project you complete a series of tasks, then run the tests in Xcode. The results of which are sent to the course, and you see the results in your browser.

The easiest way to see how this all fits together is the 10 second video Eric created for the [Code School Blog](http://blog.codeschool.com/post/62915764253/introducing-core-ios-7).

@pull right
For a more elaborate take on this course, check out the Eric's post on the [Code School Blog](http://blog.codeschool.com/post/62915764253/introducing-core-ios-7).
@

<div class='row'>
  <div class='medium-7 medium-offset-2 columns'>
    <iframe src="//player.vimeo.com/video/75897272" width="100%" height="350" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen ></iframe>
  </div>
</div>

Did you see that? We use [native browser notifications](/2013/09/08/native-javascript-notifications/) and [response streams](/2013/09/07/response-streams-with-rails-4-and-redis/) to push the latest results back immediately.

Native editing using the same tool you'd use, coupled with an interactive course with videos makes for a more direct connection between you and the code. The course prompts you with tasks to complete in Xcode, you perform them, run the test suite, and the site is updated to reflect what tasks are left to complete. The result of this is that you'll see feedback in the browser immediately following a test run from Xcode.

## Videos in Context

<div class='pull-right'>
  <p>You probably should just watch everything he's ever done.</p>
</div>

Recently [Bret Victor](http://worrydream.com/) put out an inspiring, interactive version of his last talk, [Media for Thinking the Unthinkable](http://worrydream.com/MediaForThinkingTheUnthinkable/). This presentation of the content hit close to home. Ever since [Rails for Zombies](http://railsforzombies.com), Code School's courses have featured videos, followed by in browser challenges. The only way to see the video was to navigate back to it, view the video, and then go back to the challenge. We've long known we could do better, but this format was the kick we needed at the right time.

In the footer of interactive version of his **Media for Thinking the Unthinkable** talk, Bret goes into the thought behind this method of displaying the content:

> But a talk is a poor knowledge-container. It's opaque. The viewer can't skim, browse, or get a gist at a glance. Ideas can't be looked up as needed; they feel fleeting. The medium works well for entertainment — watch and enjoy — but not for a toolbox.
[Media for Thinking the Unthinkinkable](http://worrydream.com/MediaForThinkingTheUnthinkable/)

<div class='pull-right'><p>Videos are a toolbox.</p></div>

Our videos are a toolbox. You pull one out and use to solve the challenges that come after, so why would you want to navigate away to rewatch one? Putting them in context only made sense. Each task you are prompted to complete has an associated position within the video you previously watched which you can call up with a click, at the moment you need it.

## iOS Education

[Eric Allam](https://twitter.com/eallam) and [Jon Friskics](https://twitter.com/jonfriskics) did an amazing job on the content for this course, while [Justin Mezzell](http://justinmezzell.com/) and [Dan Denney](https://twitter.com/dandenney) created an vivid design. I worked exclusively on the Rails/JavaScript side which presented some extremely exciting challenges to solve -- and served as the content for the first few posts on this blog. I don't know what the future of iOS education will be, but I'd like to think we're pushing the boundries and continuing to improve.

[Code School]: http://codeschool.com
