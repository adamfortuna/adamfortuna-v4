---
title: "Windows Live Writer Review"
permalink: windows-live-writer-review
tags: Technical, Review
---

About a week ago I decided to give [Windows Live Writer] a shot. I haven't had much luck sticking with an updater for very long lately. [Performancing] is pretty good at what it does (being a lightweight no-installation needed firefox plugin that allows posting to a variety of servies), but somehow I always seemed to forget it's there, or just need a little trial and error to get a post right. Enter Windows Live Writer.

The first thing that stands out with Windows Live Writer is the ease at which blogs can be added to be controlled. Provide the base link you'd view the site from, login and password and you're set to go (well, assuming you're using one of a few specific services). Livejournal and custom Wordpress installations are both easy installs, but unfortunately WLW doesn't play nice with [Vox] . For the hell of it I also tried [Blurty] , another [Livejournal.org] code based site, which it didn't like.

It's in, it's able to connect to my blog, now comes the fun part. To my surprise, WLW downloads the styles of your posts and displays them in the WYSIWYG window. So far for sites I've tested this has worked perfectly. It does a test post for style detection though, afterwords deleting it.

Features
--------

Ok, so we're up, it's able to connect to my blogs, it's loaded my styles- - now what can it do to distance itself from the pack?

Adding these headings is easy enough, as is the usual set of features you'd expect from any editor — Bold, italic, numbered lists, unordered lists, quotes, links and pictures. Spell checking is also available, which for me is always a plus; and saves an awkward mid-process page reload that's required to do it from a web app.

Adding maps is one of the features I really wanted to test out (and I am @ Florida idiots). Clicking on the Insert Map dialog is all that's needed to popup a search dialog. You can drag it around, resize it and eventually get the map you're wanting.

Adding pictures is just as easy as adding them into a word document. Insert the picture, set some options on it and it's ready to be inserted. When you're ready to actual publish the post you might have to configure some options. In a test post to my livejournal, an error came up saying the software was unable to attach content to the post. I thought it would just stop there, but it prompted me to set up an FTP account to automatically upload the pictures to. I gave it the info it needed to save to somewhere on [static.adamfortuna.com] and posted the page as a draft. You can see what the result was on there- - a folder created with the post name plus some extra information, then two dynamically named images, one the normal imagine, one the thumbnail. Very smooth interface.

Suggestions and Issues
----------------------

For a first release of a project I'm quite impressed with WLW. As a developer, getting something so right the first time is a huge achievement and I applaud them for that. With that, here's my suggestions for improvement and current problems.

When inserting a map into a page, there should be options for the height and width of the map, like with pictures. So far I've only seen an option to adjust margins and alignment. Hopefully a few other map options as well, like disabling the scale, or showing a minimized scale. The preview map page before it has been inserted is also a little clunky. I've been keeping my maps the same size, which means keeping the preview the same size. This wouldn't be a problem, but if it's displaying a page of suggestions for your search, it's not enough space.

When posting to a custom installed Wordpress blog ( [Florida Idiots](http://www.floridiots.us) ), I noticed that my tags had been overwritten on a post I was editing. Apparently the wp_post2tag table is being cleared out for the current post. I'm almost sure this is just because when WLW updates it updated that post it didn't provide any tags for the plugin i'm using ( [UltimateTagWarrior](http://www.neato.co.nz/ultimate-tag-warrior/) ), so it'll just be a matter of getting a WLW plugin or writing one when then time comes.

When editing a post using your blogs software (LJs web form, WP's entry form), then coming back to WLW, it should be able to update to see that changes have been made, but these don't update. There seems to be a problem with this feature in the current beta. Loading Livejournal posts gave an error when I refreshed it, making it unable to load my most recent post. The end result of this is that unless I update every-time  from WLW I'll overwrite my changes.

Posting drafts to livejournal doesn't work, but that's probably to be expected. Livejournal doesn't do drafts the same way as Wordpress. With LJ, you can have one active document at a time, so if you're filling out a post and close it, the next time you try to create a new entry it'll prompt asking if you want to "restore from draft". However when posting a draft to LJ using WLW, it simply created a public post.

  [Windows Live Writer]: http://windowslivewriter.spaces.live.com/
  [Performancing]: http://performancing.com/firefox
  [Vox]: http://dyogenez.vox.com/
  [Blurty]: http://www.blurty.com
  [Livejournal.org]: http://www.livejournal.org/
  [static.adamfortuna.com]: http://static.adamfortuna.com/images/livejournal/dyogenez/
