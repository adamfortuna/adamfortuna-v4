---
title: "Adding tasks to Remember the Milk with Alfred"
permalink: adding-tasks-to-remember-the-milk-with-alfred
tags: Personal, Productivity, Short
---

A few months ago I made the switch from QuickSilver to [Alfred](http://www.alfredapp.com/). If you’ve ever used QuickSilver you have a good idea what Alfed can do - but it does it in a single pane rather than the multi-command way QuickSilver goes about it. Amongst other abilities, it’s an application launcher that accepts additional parameters. On their site, they give an overview of the abilities:

> Alfred is a productivity application for Mac OS X, which aims to save you time in searching your local computer and the web. Whether it’s maps, Amazon, eBay, Wikipedia, you can feed your web addiction quicker than ever before.

Pairing with [Nate](http://twitter.com/#!/nbibler) at [work](http://envylabs.com), we setup Alfred on our new pairing station and I instantly saw some of the power. Setting up custom searching was the first, and easiest, feature. With how often I search GitHub and RubyGems, these shortcuts help.

![](/images/galleries/articles/alfred/gem.png)

And another for GitHub:

![](/images/galleries/articles/alfred/gh.png)


Setting these up is extremely simple. Just do a search on the site you want to add, and replace the query term with {query} within Alfred. The result looks like this:

![](/images/galleries/articles/alfred/gh-setup.png)

You should be able to follow this setup for any searches you would like to add a shortcut for.

### Setting up Remember the Milk and Alfred

My favorite addon though, is [Remember the Milk](http://rememberthemilk.com) integration via terminal. In order to use RTM, you’ll need to grab the PowerPack (paid) version of Alfred. Unfortunately this version isn’t available through the App Store, so you’ll need to download it manually from the Alfred site.

In order to add tasks from Alfred, you’ll first need to be able to add tasks from the command line. There are many ways of doing this, but following [this guide](http://ruk.ca/content/alfred-remember-milk) should help. I installed the [rumember](https://github.com/tpope/rumember) gem into its own gemset. You can then use an [RVM wrapper](http://beginrescueend.com/integration/passenger/) to be able to execute the gem from the command line, even when it isn’t the currently set gemset. Alfred will have no concept of rvm or gemsets, so this helps make it available.

```bash
~/rvm wrapper 1.9.2@research ru
~/ru_ru Do laundry ^tomorrow
```

After creating the gemset and wrapper, you should be able to add tasks to your RTM account using the command ru_ru from anywhere, regardless of the gemset you’re currently in. You can always go into ~/.rvm/bin and alias “ru” to “ru\_ru” as well, then be able to just use that.

Setting it up within Alfred is just as easy. Under Extensions &gt; Scripts, click on the + sign to add a new “Shell Script”. You can title it whatever you want. My edited version looks like this:

![](/images/galleries/articles/alfred/rtm-setup.png)

After that, you should be able to add RTM tasks easily from Alfred! There is no feedback that it’s successful or not the way I have it setup, so it’s more of a fire and forget it approach to task management.

![](/images/galleries/articles/alfred/rtm.png)

Extremely easy to fire off tasks to deal with later. It’ll even organization by date and category if you use the correct syntax in your messages. If you have any other tips that might help with RTM/Alfred integration, feel free to comment.
