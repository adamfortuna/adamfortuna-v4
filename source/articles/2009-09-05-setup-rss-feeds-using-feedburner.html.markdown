---
title: "Setup RSS Feeds using FeedBurner"
permalink: setup-rss-feeds-using-feedburner
tags: Technical, Wordpress, Short
---

I'm sure everyone has experienced this: you're reading their feeds and all of the sudden one of them has 20 new entries. Did the author of that feed suddenly go wild and start posting? Maybe they're at a special event and posting about it? No, usually it's just an error in the RSS feed where somehow the timestamps of the entries are different, causing your feedreader of choice to show you 19 articles that you've already read. This used to be very annoying, but now a days it happens so often I barely notice it — just click over to that feed, click ‘mark all as read', and go on to the next feed. One of the easiest ways to get around this is not to rely on your website to host your RSS feed. Setting up your blog to use [FeedBurner](http://www.feedburner.com) is so trivially easy, that it should be one the first time for you to do with a new Wordpress installation. Really simple steps to do it to. You ready?

### Install the Wordpress Plugin

[Install the FeedSmith plugin](http://www.google.com/support/feedburner/bin/answer.py?hl=en&amp;answer=78483) . Directions and plugin link on the Google support page, so it's pretty straightforward. Just upload the plugin and activate it from the plugins panel.

### Update your .htaccess file

Update your [.htaccess file to rewrite your /feed link](http://perishablepress.com/press/2008/03/25/redirect-wordpress-feeds-to-feedburner-via-htaccess-redux/) . This will allow people to actually add your local feed link to feedreaders, then if the destination changes it won't affect your users. For instance, if someone adds <http://adamfortuna.com/feed> to their feedreader, right now it'll just redirect to FeedBurner. Later on this might go somewhere else, but I can do that without worrying about losing my (tiny) readership. Very easy to do- and worth setting up if you plan on having your blog around for a while. Also it greatly reduces your server load not having to rely on your feed being checked every minute by loads of feed readers.
