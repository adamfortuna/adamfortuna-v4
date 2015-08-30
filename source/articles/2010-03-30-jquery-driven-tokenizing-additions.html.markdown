---
title: "jQuery Driven Tokenizing Additions"
permalink: jquery-driven-tokenizing-additions
tags: Technical, JavaScript, Short
---


Facebook got tokenized input right. If you've ever sent someone a message, or searched for someone a message you probably used what was previously a less user-friendly system to perform this same task. The idea is easy- you want to enter one or more names or other text and select matches. Gmail uses the same kind of auto-complete to allow you to email to multiple email addresses, as do a host of other sites, so it's surprising there aren't better solutions to this in the public. I came across one amazing solution for this when I was working on [MovieFly](http://moviefly.org) a few months ago, and was able to expand it with a few more options while working on [SponsoredTweets](http://sponsoredtweets.com) .

The [jQuery Tokenizing Autocomplete](http://loopj.com/2009/04/25/jquery-plugin-tokenizing-autocomplete-text-entry/) was released last year, with [some nice additions to it](http://github.com/loopj/jQuery-Tokenizing-Autocomplete-Plugin) in December. It's an extremely rich plugin that behaves very similar to the Facebook version. You can select previously entered tokens and delete them, navigate completely by keyboard, or with the mouse- it's amazing. [My branch](https://github.com/adamfortuna/jQuery-Tokenizing-Autocomplete-Plugin) has a few additions that were used on SponsoredTweets including suggestions when there are no matches.
