---
title: Creating Photo Albums with Lightroom
date: 2015-12-09
tags: Technical
permalink: creating-photo-albums-with-lightroom
description: Lightroom and Middleman sitting in a tree
---

A few months ago, I wrote a little bit about [How I Create Photo Albums](/articles/how-i-create-photo-albums). This touched on some nifty features -- Frontmatter, Middleman data files, creating a Markdown variant and using a grid system to layout these photos.

In the "next steps" section, I mentioned that the bottleneck of this process was creating the YML files -- mapping the photos to how they'll show up in a grid. Solving this problem brought me a little bit outside of Middleman, but I was thinking this would be a good one to illustrate what you can do with Middleman.

## The Parts

@pull right
Lightroom helps organize, edit, and remix photos more than I ever imagined.
@

@pull left
![Lightroom](/images/galleries/logos/lightroom.png){: .icon}
@

There are a number of moving parts in creating these. All of the photo editing happens in __Lightroom__. I've only touched the surface of Lightroom, having just started using it earlier this year, but I'm already seeing this as an essential part of my process.

The key part for tying together Lightroom and Ruby is [Jeffrey's "Run Any Command" Lightroom Export Plugin](http://regex.info/blog/lightroom-goodies/run-any-command). This Lightroom plugin allows you to run something from the command line after an export completes. You can even pass in a path to a temporary manifest file that contains paths to all photos that were exported! You can probably see where this is going, but this allows you to Lightroom to talk to Ruby.

@pull left
![Ruby](/images/galleries/logos/ruby.png){: .icon}
@


The __Ruby__ part isn't Middleman just yet. This is a plain old ruby script that's run from the command line. In my case it shares the same models with my Middleman app, but is the glue that takes input (the list of photos that Lightroom generated) and creates the blog post with those images.

After the post-process script runs, it'll generate all files needed for a blog post, as well as create thumbnails for the photos and all that. The next step is to manually go in and write the blog post (that's still not automated unfortunately) and making any tweaks to how photos are shown in the galleries.

## The Process

From beginning to when you're able to see the actual post, here is how these gallery posts are created. Every one of these steps happens in Lightroom now, and it's only after we have the initial export and I started tweaking things and adding the blog content that I move over to Middleman and Markdown.

@pull right
This might seem like a lot, but if you're actually looking at your photos, you might already be doing these things.
@

1. Import all photos into Lightroom.
2. Move photos into folders based on the event or group.
3. Go through and Flag (CMD+Shift+p) or Reject (CMD+Shift+x) all photos.
4. Update the metadata on each flagged photos to include title, caption, author and rating.
5. Develop/Edit each photo to your hearts content.
6. Export all photos to a folder in Middleman using the format "postname-{folder}-{sequence}-r{rating}"
7. Add a post-process script (Ruby) that converts these photos into a blog post!
8. Click "Export" and watch the magic happen.

## Walkthrough

Here's a short (17 minute) walkthrough of the entire process for creating these galleries from beginning to end. I go over these steps, and give an overview of individual parts involved in creating something like this.

<div class='wrap--wide'><iframe width="100%" height="610" src="https://www.youtube.com/embed/lNYLvMjdoxE?rel=0&amp;vq=hd1080" frameborder="0" allowfullscreen></iframe></div>

## Gotchas

The biggest gotcha with all of this was that when the post-process Ruby script was run, it didn't have an `ENV['PATH']` variable defined. ImageMagick is used as part of the Ruby side though, which is accessed via the command line. The workaround for this was updating the post-process call to include full paths:

```bash
PATH="/usr/local/bin:/usr/bin";
FILE="{MANIFEST}";
/Users/adam/.rbenv/versions/2.2.2/bin/ruby /Users/adam/code/personal/adamfortuna.com/bin/post_process.rb
```

Took some deep debugging to find that PATH wasn't defined, so hopefully this helps someone else figure that out sooner!

## Process Suggestions

This is still a work in progress, but it's getting there. The Ruby code is embarrassingly bad, but it works -- and that's all I need for a personal project like this. I'm curious to hear if anyone else is using any Lightroom plugins to help automate their workflows. That's a good low hanging fruit for optimization.
