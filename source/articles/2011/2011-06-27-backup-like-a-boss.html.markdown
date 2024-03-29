---
title: "Home Backup Like a Boss"
permalink: home-backup-like-a-boss
tags: Personal, Preparation
---

After hearing about the [FBI Raid on Marco Arment's servers](http://5by5.tv/buildanalyze/30), it got me interested in how he was doing backups. I've been slowly tweaking my own backup procedures over the last few years -- to the point of being borderline obsessed with having local backups. A few years ago in 2002, a failing SATA drive containing my windows partition and all my files left me high and dry and without just about any backups of anything. This was a time before [Dropbox](http://db.tt/ueGBRCn) and other synchronizing services had come along to make things easier, and I hadn't taken the step on my own to make backup a priority.

Two years ago when I was setting up my [home media center](http://blog.adamfortuna.com/building-the-ultimate-media-center-part-3-bac/), I took a first stab at serious backup. Since then I've been gradually tweaking my system and trying new things. What follows is what worked for me.

### What's being backed up?

In this case I'm talking about a lot of data, but split over a few discreet sections:

* Under 60 GB of photos, documents, code and general files.
* About 150 GB of music, mostly ripped from my Mom's extensive CD collection when she was a DJ, plus my iTunes downloads.
* About _(gulp)_ 7 TB of movies. This includes a DVD rip of just every movie I've ever bought.
* 3 Macs are being backed up with TimeMachine (Mac Mini and 2 MacBook Pros)

@pull right
![](/images/galleries/articles/media_center/mini-small.png){:.center}
@

I eased back to the steam-only version of NetFlix, so this is (luckily) the size of the movies folder no longer going up. Occasionally movies/TV are pruned down, so hopefully that'll be down to a "manageable" 5TB soon enough.

### What Hardware is this Using?

* Dedicated Seagate 1TB TimeMachine Hard Drive
* [4-bay USB/Firewire Drobo](http://www.amazon.com/Data-Robotics-FireWire-Storage-DR04DD10/dp/B001CZ9ZEE/ref=sr_1_1?ie=UTF8&qid=1309218669&sr=8-1&tag=adamfortuna-20) with 4x2TB drives (~5.6TB) connected to the MacMini
* "4-bay MediaSonic Raid Enclosure":http://www.amazon.com/Mediasonic-eSATA-3-5-Inch-Enclosure-HFR2-SU3S2/dp/B003YFHEAC/ref=pd_sim_e_6?tag=adamfortuna-20 with 4x1TB (~3TB) connected to the MacMini
* 2 x Western Digital 3TB Drive connected to the Mac Mini (used exclusively for backups).

![](/images/galleries/articles/media_center/drobo.png){:.center}
![](/images/galleries/articles/media_center/mediasonic.png){:.center}


The Drobo and MediaSonic both can withstand a single drive failure with no data loss, which is an ideal first line of defense. I've heard from many reviews that the performance of the Drobo is awful, but I haven't had too many issues. The initial load of data onto it is a long, slow, painful experience -- and adding a new drive can require upwards of a day before you can use it, but for general use I haven't had any issues.

I'd consider the MediaSonic enclosure as a lower priced alternative. The downside is needing 4 drives up front, but that's an issue you'll encounter with any RAID solution. You have the option of choosing the level of Raid you want, and formatting takes only a few minutes.

It's been a a year or two since I looked into hardware, but these have both lasted well without any data loss, and without any failed drives (so far).

### Software Makes it Happen

@pull right
![](/images/galleries/articles/media_center/cronosync.png)
@

There's a few important pieces of software that keep things in sync. In my "previous post":http://blog.adamfortuna.com/building-the-ultimate-media-center-part-3-bac/ I was using mostly cron jobs - which works, but were a little rough around the edges. Since then I've added a few more to the mix:

* TimeMachine is installed on all 3 Macs
* [Chronosync](http://www.econtechnologies.com/pages/cs/chrono_overview.html) installed everywhere
* [Backblaze](http://www.backblaze.com/partner/af1782) ($50/year) on Mac Mini
* [Dropbox](http://db.tt/ueGBRCn) ($99/year) on laptop

Now, if I had less than 100 GB of total data, I'd just use Dropbox and call it a day. I'd probably even enable the "Packrat" option for unlimited undo history. Even with the recent "Dropbox authentication bug":http://blog.dropbox.com/?p=821 it's still the best tool on the market. There are other ways to "roll your own Dropbox":http://www.readwriteweb.com/cloud/2011/05/4-ways-to-build-your-own-dropbox.php that may be worth checking out as well. Dropbox has the added bonus of having an API that other tools can interact with, that you wouldn't get from a home rolled solution.

It's also possible to increase the size of your Dropbox with referrals and other promotions they offer. My 50 GB box is up to 67.75 GB at the moment, just by taking advantage of their offer to increase the size with referrals. The additional amount of space for each referral is dependent on your pricing level, so you get more extra space for a referral when you're on the 50 GB plan than on the free plan.

Backblaze is a tool I haven't heard much fuss about, but for me it's been a reliable, cost efficient and effective tool in my backup strategy. The Mac app for Backblaze installs itself into your system preferences and is completely controlled from there. You can specify which folders/drives you want to keep backed up, and tweak the speed to upload.

It took upwards of 3 months to upload 6 TB to Backblaze (which Brighthouse luckily didn't have any issues with). Since then it's stayed in sync a few days at any given time. The contents on the drive aren't in constant flux, so often it's updated within a few minutes. If you're on a slow connection, this might not be possible, but [Road Runner Lightning](http://brighthouse.com/central-florida/shop/internet/road-runner-lightning) or FIOS will make the process a lot smoother.


### Bringing it All Together

The Drobo and Mediasonic devices serve as file storage for archived DVDs, and also store all music I've ever ripped/downloaded. Both devices allow for a single drive failure without the loss of data - and advantage over the standalone Western Digital 3TB drives which if they fail, all data is lost.

h4. Time Machine

@pull left
![](/images/galleries/articles/media_center/timemachine.png)
@

The 2 MacBook Pros and the Mac Mini are backed up constantly to Time Machine. Although not encouraged supported, you can plug a USB hard drive into an Airport Extreme and use it as a TimeMachine drive. From my experience, you can't do a first backup via USB then plug it in there either -- you have to do all backups and restores while it is connected to the Airport Extreme (probably a paths thing).

h4. Music

Music on my main computer isn't backed up to TimeMachine. Usually I have about 100GB of music, podcasts and other videos from iTunes University which is instead backed up to the Mediasonic device. Chronosync does the work of keeping a nightly snapshot of my entire music folder on one of those drives. If I grab a new album off iTunes, or rip a CD, it'll be backed up that same day.

@pull left
![](/images/galleries/articles/media_center/itunes.png)
@

The MediaSonic has 2 Music folders actually. It has an "In Use" folder and an "Archive" folder. The MacBook Pro music folder is mirrored to "In Use" - which is always a snapshot of what's currently on my laptop. Later, the Mac Mini does a sync to a second "Archive" folder. This may sound redundant, but that's because for much of the data it is.

The nice part is that if I delete something from my laptop, it'll also be deleted from the "In Use" copy, but the "Archive" folder will retain a copy. The goal of all this is that I can restore my music directly at anytime, not eat up space on the TimeMachine drive, and have an canonical archive for all music.

h4. In-House Backups

The MediaSonic drive is synced nightly to one of the WD 3TB drives. The sizes match, so it's a clean mirror. Chronosync handles the scheduling and syncing, keeping it easy to edit as well. 3 TB of data from the Drobo is backed up to the other MediaSonic Drive nightly as well. That leaves about 2.6 TB of data that's not duplicated in house, but is still available on Backblaze.

### The End Result

Any single hard drive or device can fail with a backup readily at hand. It's important to not only protect against a single hard drive failure but a single device failure. Having a device like a Drobo or a Raid helps with redundancy, but it's not a backup -- if the device itself malfunctions or corrupts your data, you're out of luck. By having a in house backup of these, I still have access to anything important at a moments notice.

Setting up an offsite backup plan is annoying at first, but once it's in place it's a huge relief. At the moment I'm very happy with both Backblaze and Dropbox, and plan to renew both. I haven't priced out how much it would cost to store 6 TB on S3, but I imagine it'd be below $50 a year. The nice part of Backblaze is that they can mail you hard drives loaded with your data in the event of a failure -- or you can just download specific files.

One obvious gap in my setup is offsite backups for my TimeMachine drive. These could be synced up with BackBlaze as well, but at the moment Backblaze requires all backed up drives to be physically connected to the machine with it installed.

### What's your Plan?

I'm always interested to see what people are doing to backup large amounts of data like this. If you're backing up a large amount of files, or even a small amount, I'd be interested in hearing what your strategy is!
