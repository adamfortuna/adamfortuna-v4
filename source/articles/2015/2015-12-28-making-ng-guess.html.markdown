---
title: Making ng-guess.com
date: 2015-12-28
tags: Technical
permalink: making-ng-guess
description: Creating an launching a side project in a week
---

A little over a week ago I was [reading a post on Reddit](https://www.reddit.com/r/angularjs/comments/3vv2x8/should_i_start_a_new_project_in_angular_1/) asking if someone should start a new project in Angular 1.x with Angular 2 "right around the corner". When it comes to open source projects, time and time again it's been a bad idea to try to make plans based on release dates. At [Code School](https://www.codeschool.com) this comes up a lot, since we try to put out content around the time when a technology is hitting major milestones -- but that's not always possible.

## The Idea

This got me thinking -- there's a lot of people posting in this thread saying Angular 2 is going to be released on __some date__. All of these are nothing more than guesses. I wonder if a larger number of people made a guess if we would get a better collective guess on when Angular 2 might be coming out?

With this question in mind, I registered [ng-guess.com](http://ng-guess.com) with the intention of answering this very specific question. I also wanted to create something super simple and launch it in the smallest timeframe.

## Getting Started

I'm a huge proponent for creating a base repository to use when creating applications. These help get over the hump when setting up a project to where you are actually able to start seeing something working. I have a front-end template I use for this, [adamfortuna/ng-seed](https://github.com/adamfortuna/angular-seed), that includes Angular 1.5, Lodash, Angular Route and Bootstrap 4. I have a feeling when I want to give React.js or Angular 2 a try, one of the first things I'll do will be creating a seed repo for it.

For this project, I planned out what I'd want the user experience to look like on paper. Basically just a single page where they could authenticate with GitHub, choose a date and then see the results from other people. Not too much to it!

## Technology Stack

Since I wanted this to be a free site and not to have to worry about hosting, creating it as a static site was the obvious route to go. This would mean I'd need to use some cloud database storage, and it'd affect a few other things. With that in mind I started adding some dependencies!

* Firebase - Cloud database to use for storing results and easy authentication
* GitHub - Authentication via GitHub is super easy using Firebase. It took less than an hour to get bootstrapped and auth up and running.
* Angular 1.5 - With only a few pieces of functionality, this application could easily have been accomplished without this.
* D3.js - The graph of results is shown using D3. It actually updates in realtime, so if a lot of people are voting, you'll see it move around.

## The Code

The actual code wasn't given much thought -- it was just thrown together. If you're curious about how something like this works, it's available on GitHub at [adamfortuna/ng-guess](https://github.com/adamfortuna/ng-guess). There's no tests, no refactoring to make things pretty -- this is a quick and dirty app.

## The Release

Having this as a static application with the source available meant I could host it on GitHub pages! Whenever I can use GitHub pages for a project I take advantage of it. The root application needs to be built though, so how do we go about deploying just the "public" folder to our GitHub branch?

Turns out there's a cool Git command for this:

```bash
ng-guess $ git subtree push --prefix public origin gh-pages
```

Running this will push up your local `public` folder to the `gh-pages` branch on your `origin` remote. This is exactly what you want when you publish the site. To make things easier, you can even add this as a git alias to make your life easier by adding this alias to your "~/.gitconfig" file.

```
[alias]
  publish = subtree push --prefix public origin gh-pages
```

Now you can run `git publish` and it'll push up your application and release it!

## Lessons Learned

It's OK to do something small for fun and release it. I've never been a fan of doing small programming exercises for fun (loops, algorithms, etc), but creating a small functional website is a ton of fun for me. I'm going to look for more opportunities to try smaller iterations like this in the future when learning new technologies. Diving right into a new technology on a multi-month project increases the likelihood that something will go wrong and you'll end up not coming away with a good takeaway.

If you're curious to make a guess on when Angular 2 will be released, head over to [ng-guess.com](http://ng-guess.com)!

## _Update_

During the week between having the idea and releasing the application, [Angular 2 beta was released](http://angularjs.blogspot.com/2015/12/angular-2-beta.html)! If you're curious about checking it out, now is a good time.
