---
title: "Getting Rails 3 Beta Setup"
permalink: getting-rails-3-beta-setup
tags: Technical, Ruby, Short
---

If you use Ruby on Rails, you've probably heard by now about the release of the [Rails 3.0 beta](http://weblog.rubyonrails.org/2009/2/5/this-week-in-rails-3-0) yesterday. There's been [a lot leading up to this release](http://www.engineyard.com/blog/2010/rails-3-beta-is-out-a-retrospective/) , so naturally most of the rails world is eager to jump in and give it a try. Saturday morning is a great time to get started, so I decided to give it a try. First off, I wanted to make sure I had a more up to date version of Ruby. Rails 3.0 beta and up will require Ruby 1.8.7 or higher. If you're running Snow Leopard you probably already have this, but can always do a `ruby- v` to check your current Ruby version. The easiest way I've found to run multiple versions of ruby is using the [rvm](http://rvm.beginrescueend.com/install/) gem. It handles everything needed for running multiple versions of Ruby, including Rubygems. Just install the gem and go from there:

```bash
link:~ adam$ gem install rvm
link:~ adam$ rvm-install
link:~ adam$ mate ~/.bash_profile
link:~ adam$ ruby- v
link:~ adam$ rvm install 1.9.1
link:~ adam$ rvm use 1.9.1
link:~ adam$ gem install tzinfo builder memcache-client
link:~ adam$ gem install rack rack-test rack-mount
link:~ adam$ gem install erubis mail text-format
link:~ adam$ gem install thor bundler i18n
link:~ adam$ gem install rails
```

At this point, I tried to create a new rails project using the usual `rails [projectname]` , but I ended up getting the following error:


> link:research adam$ rails beta /Library/Ruby/Site/1.8/rubygems.rb:384:in `bin_path': can't find executable rails for rails-3.0.0.beta (Gem::Exception) from /usr/bin/rails:19

A [lucky comment in another blog](http://www.rubyinside.com/how-to-install-rails-3-0-prerelease-beta-2955.html) showed a fix for this:

```bash
link:~ adam$ gem install railties —pre
```

After that I was able to create a project the usual way, and start messing around the latest version of Rails. Looking forward to upgrading some existing sites!

```bash
link:research adam$ rails testsite
link:research adam$ cd testsite
link:testsite adam$ rails server
```
