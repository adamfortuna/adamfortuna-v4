---
title: "The Amazingness of Delayed_job for Rails"
permalink: the-amazingness-of-delayedjob-for-rails
tags: Technical, Ruby
---

Long loading pages make people leave your site. Amazon and Google know this, and have optimized their sites accordingly. For Google, a half second in page load time decreased traffic and ad revenues by 20%! For Amazon every 100 ms resulted in decreased sales by 1%. For these companies, a half a second could mean a billion dollars in potential earnings. The book [Website Optimization](http://www.amazon.com/dp/0596515081) goes into this in more detail on [the psychology of web performance](http://www.websiteoptimization.com/speed/tweak/psychology-web-performance/) , which poses a number of advantages of performance. If you're taking speed seriously, you're going to want to do all you can make a better user experience- - both on the front end loading speed and the backend.

### So what's this delayed_job thing?

Optimizing some of the worst offenders is where delayed_job comes in. It shifts long running tasks within a page request to a later time, where it won't impact the user. Delayed_job installs as a Ruby on Rails plugin from [it's github location](http://github.com/tobi/delayed_job) . It acts like a queuing service for your application, with your database storing the queue itself. This has a number of advantages over another messaging queue like MQ, XMPP or [Starling](http://github.com/starling/starling/tree/master) and [Workling](http://github.com/purzelrakete/workling/tree/master) . With your database storing your queue, all you need is a delayed_job process running that will repeatedly query your database for new items. Removing a job from the queue is as easy as removing a row from a table.

### What should be processed in the background?

So we know page load time is important, but what can we speed up? One of the easiest things is long running processes that don't need immediate feedback to the user. Hitting a credit card gateway wouldn't be a good example — in that case you'd want to give feedback to the user immediately. But for processes where the user might not even know something is happening, or if when you can show a placeholder while their request is processing, delayed_job makes a lot of sense. Here's a few examples:

-   Sending emails (surprisingly slow!)
-   Resizing images
-   Processing uploads (like importing a big csv)
-   Hitting external services (like updating twitter stats for instance)
-   [more listed on the delayed_job github page](http://github.com/tobi/delayed_job/tree/master)

### Getting it Setup

Just install the plugin as you would any other.

```bash
ruby script/plugin install git://github.com/tobi/delayed_job.git
```

Create a migration and fill it in with the database setup in _ delayed_job/spec/database.rb_ . At this time here's what's included.

```bash
ruby script/generate migration create_table_for_delayed_job
``

```ruby
class CreateTableForDelayedJob
  def self.up
    create_table :claims do |t|
      t.integer :priority, :default => 0
      t.integer :attempts, :default => 0
      t.text :handler
      t.string :last_error
      t.datetime :run_at
      t.datetime :locked_at
      t.string :locked_by
      t.datetime :failed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :delayed_jobs
  end
end
```

Just save it and run your migrations.

```bash
$ rake db:migrate
```

### Column Explanation

Most of the columns in the table are self explanatory. **Priority** can be anything, positive or negative, and it will be processed from largest to smallest. You can change priority of items in the queue at anytime, and they'll be picked up that order. **Attempts** is, of course, how many times the job has been attempted. The number of attempts determines how long to wait before the next attempt. Originally the job is picked up in priority order, and will not be run again for _ 5+N^4 seconds_ , where N is the number of attemtps. By default, delayed_job items will be attempted 25 times, with just over 4 days between try 24 and 25. **Handler** is the YAML representation of the handler objects and it's input (discussed more later). **last_error** is the message of the last error, while **locked_by** contains the server name, and process ID of delayed_job process that's currently processing that item. This allows for multiple servers to process the queue, and for an easy overview of what each server is doing.

### Creating Delayed Jobs Handlers

Creating a delayed job handler is probably the easiest part. There's a great article on [RailsTips](http://railstips.org/2008/11/19/delayed-gratification-with-rails) with a few more examples, including using delayed_job to send out emails. I actually prefer using [deliver_later](http://github.com/mtodd/deliver_later/tree/master) for this, so that we can archive emails, but clear out processed jobs. As for the handler, just create an object that receives whatever input you need. This can be full out ActiveRecord objects if you want, but those will be serialized and deserialized at runtime, so it makes more sense to just store references and load the objects at runtime. For instance, lets say you want to grab all of a users friends from twitter after they logged in, you might do something like this.

### Adding Delayed_jobs

Let's say you want to update friends when a user logs in. In your sessions_controller, or maybe in an after_create in your Session model, you could add that user onto the queue.

```ruby
Delayed::Job.enqueue(LoadTwitterFriendsJob.new(user.id, user.twitter_screen_name), 0, 5.minutes.from_now)
```

In this case, the item will be added with a priority of 0 (lowest), and set to run no sooner than 5 minutes. The _ LoadTwitterFriendsJob_ object will be saved as a YAML object with the payload passed in.

### Processing the Queue

Delayed_job comes with a helpful task to get you off the ground fast- _ rake jobs:work_ , which you can keep open and monitor the progress of the queue. You can also pass in a rails environment here as well, such as *rake jobs:work RAILS_ENV=qa* . The github page has directions on how to [daemonize the process using the daemon ruby gem](http://wiki.github.com/tobi/delayed_job/running-delayedworker-as-a-daemon) .

```ruby
# start the worker daemon
$ ruby script/delayed_job start -- production
# stop it
$ ruby script/delayed_job stop -- production
```

This will save a log file and pid file for the delayed_job process for you. You can setup something like [Monit](http://mmonit.com/monit/) to monitor this process to make sure it's running and not acting out at all times.

### Update your Deploy Scripts

The last bit can be pulled directly from the [MagnionLabs](http://www.magnionlabs.com/2009/2/28/background-job-processing-in-rails-with-delayed_job) article — updating your dpeloy script. Delayed_job needs to be restarted everytime you deploy, otherwise it'll be using an outdated version of your application to process the queue. This might not even be noticeable at first, but eventually this might end up in catastrophe.

```ruby
# add this to config/deploy.rb
namespace:delayed_job do
  desc "Start delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path};
    script/delayed_job start -- #{stage}"
  end

  desc "Stop delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_path};
    script/delayed_job stop -- #{stage}"
  end

  desc "Restart delayed_job process"
  task :restart, :roles => :app do
    run "cd #{current_path};
    script/delayed_job restart -- #{stage}"
  end
end
after "deploy:start", "delayed_job:start"
after "deploy:stop", "delayed_job:stop"
after "deploy:restart", "delayed_job:restart"
```

If you're using multistage Capistrano deploys, it'll use the stage you're currently deploying to. Otherwise, you'll probably need to replace that with RAILS_ENV. Also, the _ restart_ task depends on the delayed_job process already running. If you're using monit and can mostly guanantee this you can leave it as it is, but otherwise you might want to change the restart role to include stopping and starting. Also you might have to _ chown_ the resulting log file generated.

### Finishing Up

By default jobs will be deleted from the delayed_jobs table after being run. You can customize this yourself, as with the other defaults for max \# of tries and the max runtime of any single process. Read more about that in the readme that comes with the plugin. If ever you want to clear out the queue altogether you can always run `rake jobs:clear` and start over fresh!
