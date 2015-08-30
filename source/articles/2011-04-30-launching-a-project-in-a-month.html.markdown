---
title: "Launching a Project in a Month"
permalink: launching-a-project-in-a-month
tags: Technical, Self Improvement
---

After leaving from my last job in mid March, I decided I wanted to get some Rails 3 experience as soon as possible. The best way to do this? Build a site that I've always wanted to do! The idea for [Line of Thought](http://lineofthought.com/) had been around in my mind for a long time (the domain was registered back in 2004 when I had the idea). The idea? A place to track and share what technologies power a specific website - or see a list of sites powered by something.

I see this as hitting a niche for a few specific groups. Developers wanting to…

-   Learn more about a specific website.
-   Share what technology their website uses.
-   Find out what's hot that they should be paying attention to.
-   See which sites are using a specific tool, framework or whatever.

I was lucky enough to have a few week gap between jobs, so as long as I had a goal for those weeks I could make the most of it. It's not often we have an idea to work on, the desire and skills to do it, and the financial availability to pull it off on our own as a full-time thing. Development picked up on Line of Thought on my first unemployed day and continued for nearly everyday for my 4 week break before starting over at [EnyLabs](http://envylabs.com/) earlier this month.

This was a project with a very limited scope, so it was very doable by one person. Most days I worked from home, but at least once a week I'd try coworking where ever I could find a desk. The goal of the project wasn't to create the next big money making site, but create something I'd want to use that the web was missing. A side goal was also to just get this idea that I'd had in my mind for 6 years out there.

### Technology Behind the Scenes

One advantage of Line of Thought is that it makes it dead simple to share what powers the site. For instance, the [technology behind Line of Thought](http://lineofthought.com/sites/lineofthought) contains a more detailed list of specific libraries than you'd likely see listed out in a blog post. I'll go over a few of the choices.

### Rails 3

The application itself is written Ruby on Rails 3. It was my first shot at a Rails 3 app, so often I'd start out doing something the Rails 2 way before discovering the *Rails 3 way*. Since I'm now working there it'll sound like a plug, but the [Rails 3 Best Practices Course](http://www.codeschool.com/courses/rails-best-practices) was a huge help in making the transition from Rails 2 to Rails 3 for me.

### Apache Solr

The app is hosted on [Heroku](http://lineofthought.com/tools/heroku), and for the most part costs almost nothing to run. The site was initially running [Apache Solr](http://lineofthought.com/tools/apache-solr) behind the scenes. Solr using Sunspot was used for site wide search, category drill down and autocomplete. The autocomplete part was fun, and only takes a few lines to implement:

```
class Tool < ActiveRecord::Base
  def self.autocomplete(q = "")
    search do
      with(:lower_name).starting_with(q.downcase)
    end
  end
end
```

### Delayed Job

There are a number of actions that hit external services (loading site title and description, pagerank and alexa). All of these happen in a [DelayedJob](http://lineofthought.com/tools/delayedjob) and don't affect the dynos (which process only web requests). The [Workless](https://github.com/lostboy/workless) gem is used to automatically scale Job runners on Heroku - which saves a good deal of money. Because of this architecture, and optimizing the page load times I can control down to under 100ms for all GET requests, it should scale up extremely well. There's places I can still add caching, but for now the only cached page is the homepage using Memcached.

### jQuery UI Autocomplete

One of my favorite discoveries was the easily extendible autocomplete system in the latest [jQuery UI](http://jqueryui.com/demos/autocomplete/). When you're adding the tools used on a specific site, it uses this autocomplete system to grab the results and show the favicon of the site. You can override the renderer used by jQuery UI, which is how we create the nice list item with a favicon, tool name and URL - then after a tool is chosen the tool ID is set to a hidden field while name and URL of the tool are shown to the user. Only a few lines of jQuery to do all this.

![]({{site.url}}/media/screenshots/lineofthought-autocomplete.png)

### Pismo Gem

One fun library I ran into was the [Pismo](https://github.com/peterc/pismo) gem. It's used to analyze the response from pages, as well as parse favicon, title and description. One added bonus is that when people add new tools, we can automatically try to classify them based on the content of the tools homepage. If it mentions framework 4 times and ruby 3 times, you can take a good guess as to what the tool is written in and what it does. There's still a few more steps to take with this, but the basics are set in place.

### Jekyll

The Blog is running on GitHub Pages using [Jekyll](https://github.com/mojombo/jekyll). I enjoyed working with Jekyll so much that I decided to move this blog over to it as well. If you're looking for a simple blogging platform that you can host pretty much anywhere, it's worth a shot.

### Lessons Learned

Like with any site I had high hopes for a launch - even though it was written almost entirely in a 3 week period. The launch is just a starting point for getting feedback though, but it has been a valuable step towards finding out what I should focus on based on what people are actually using.

Search was completely over-engineered. You really don't need solr to start with if you don't even know if you'll have any traffic. I really wanted to use it for something to get some experience, and for that I'm glad I did. In the end though, I added an option to turn Solr off and have the site degrade to using SQL for everything. With an extremely small database at the moment, this is still extremely fast, and if the site does take off Solr can always be turned on.

Downgrade as fast as you upgrade. If you have allocated tons of resources but no one is there, have a plan to scale down. Right now the site is running, but I'm not pushing traffic towards it. On the bright side it's cheap to keep it running.

It's not important to launch with a professional design if you're bootstrapped or still working out the core concepts. I could have spent some money to hire a designer, but I didn't have a good idea of what the pages were going to do until the last week. For instance, based on feedback from the initial release to a few alpha users, I got rid of an entire page. Previously there was a separate page to manage tools for a site. This was basically the same as the tools list, but with a form at the top, and editable. By combining these two pages with some Javascript, and tweaking the user flow when they add a site, the result is a lot more straightforward to new users.

Could I have just done this project in my spare time instead? Yes, definitely. I was under an NDA at the time though, so unfortunately the project would have been owned my previous employer. The same was true about my past 2 jobs actually, which was one reason the idea sat around as long as it did (that and doing [other](http://arcadefly.com) fun [projects](http://moviefly.org)). Unfortunately in Florida this is a common practice, but from [what I've read](http://answers.onstartups.com/questions/19422/if-im-working-at-a-company-do-they-have-intellectual-property-rights-to-the-stu) this isn't allowed in California.

If you have an idea for a site, build it! You can worry about not doing your idea justice, or you can start working towards it and iterate until it meets your needs.
