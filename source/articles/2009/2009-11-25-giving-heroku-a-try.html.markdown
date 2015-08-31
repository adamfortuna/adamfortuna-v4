---
title: "Giving Heroku a Try"
permalink: giving-heroku-a-try
tags: Technical, Ruby
---

If you haven't heard of [Heroku](http://heroku.com/) , you're not alone. Heroku is a cloud host for Ruby on Rails driven sites that is relatively new on the scene. They've been in private mode for nearly a year, but recently their growth has skyrocketed. This growth is based on a few core features of their platform which are typically pain points for getting projects deployed.

### What is Heroku

The trouble with most sites and descriptions of Heroku, is that they boil the service down to too small a line. The description on their site even goes this far — "Ruby Cloud Platform as a Service". To put it in laymans terms, they're a Cloud host for ruby websites (Rails, Sinatra, Rack, Merb). All Heroku sites run the same base [base platform](http://docs.heroku.com/technologies) which includes some familiar faces if you've looked into Ruby hosting.

-   Operating System : Debian 4.0
-   Ruby : MRI 1.8.6
-   Ruby App Server : Thin
-   Web Server : Nginx 0.6.32
-   Database : PostgreSQL 8.3.5
-   HTTP cache/accelerator : Varnish 2.0.2

One of the most important things to me is that Heroku handles keeping all of these running and up to date. You don't have to worry about getting a call that the database server has crashed, or one of the servers is out of memory — they do all that for you. You can think of it as managed hosting, but they're managing a cloud rather than single servers.

-   Insanely easy setup
-   No Capistrano for Deployment - instead you just push to a git repository on their servers
-   No worrying about apache/nginx/mongrel/passenger - they just spin up a thin clients behind nginx.
-   Methods for simplifying many common tasks including database importing, exporting and site backups

### Setup is Almost as Easy as They Say

Setting up you application to get on Heroku doesn't take very long. Actually, during lunch at work today I got a Heroku app setup, just to try it out. You can follow the [Heroku Quickstart Guide](http://docs.heroku.com/quickstart) , so I won't repeat it here. My only advice is to do everything you can from from the command line, rather than editing settings on the website. If your local copy and the remote copy get out of date (like if you rename an app for example), you'll hit a speedbump and have to sift through the docs. The web management interface for Heroku is a beauty though, and coupled with the robust heroku gem, you can do a lot right out of the gate. So after you get your database on Heroku migrated, you'll probably want to load some data in it. Heroku has a very helpful command to get you started.

```bash
$ heroku db:push mysql://root@localhost/arcadefly_development?encoding=utf8
```

You only need db:push, but without the "utf8" encoding specification, you may run into some problems converting from mysql to PostgreSQL. So far the only main difference in Mysql to Postgres for [ArcadeFly](http://www.arcadefly.com) (temp Heroku url until dns updates) is that I used 1 or 0 for booleans as strings in a few places. I changed these to true/false instead, pushed out the change and it worked fine. Pushed out? Yeah you can deploy a heroku site with a simple git push. The initial setup already added Heroku to your git setup, so deploying is just pushing.

```bash
$ git push heroku master
```

They posted a Vimeo video about getting started that should help get an idea of just how easy setup is:

[Creating an app on Heroku in from](http://vimeo.com/6916740) [heroku](http://vimeo.com/heroku) on [Vimeo](http://vimeo.com).

### Limitations when Using Heroku

Under Heroku you're set a very specific set of server software, as you know from the above listing. These luckily cover the vast majority of Rails sites, so there's nothing wrong with that. What you don't get is full SSH access to the server that you may have become used to. Instead, most access is done using the Heroku gem. Here's a few things that you can do. You can jump right into a console on production:

```bash
link:arcadefly adam$ heroku console
a = Arcade.first
```

Using the @ heroku logs@ command, you can get the last bit of your production log real fast. Running rake tasks is as simple as `heroku rake db:migrate` . You never need to specify environment with Heroku — everything on Heroku is production. Probably the biggest limitation is that there is no access to the filesystem except in /tmp. In order to save and manage files, you should instead use S3. Since Heroku runs on EC2, there is no file transfer charge for files between your S3 account and your Heroku servers since they are both in the same data center.

### Expanding Heroku

It's free to get started on Heroku. You can create a rails site with 1 Dyno (1 Thin server), have a daily cron job, get a PostgreSQL database and even point your own custom domain there. You can expand this with more thin clients, delayed\_jobs and [much more](http://addons.heroku.com/) at a price. I like the idea of having delayed\_job processes running in the cloud rather than possibly slowing down the site. Unfortunately there's no public memcache yet, although it's in private beta. I'm still just getting my feet wet with Heroku, but look forward to seeing how [ArcadeFly](http://www.arcadefly.com) does there.
