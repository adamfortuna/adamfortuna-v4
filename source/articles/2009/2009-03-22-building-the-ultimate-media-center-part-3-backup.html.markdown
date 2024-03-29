---
title: "Building the Ultimate Media Center, Part 3: Backup"
permalink: building-the-ultimate-media-center-part-3-backup
tags: Personal
date: 2009/03/22
---

Describing what I’ve been working on so far as a media center may not be quite sufficient. Now a days term “home server” seems to do it a bit more justice, and if a home computer is on full time you’ll certainly want to get the most out of it. If you’ve ever wanted to do backups within your home, you might’ve looked into [Windows Home Server](http://www.microsoft.com/windows/products/winfamily/windowshomeserver/default.mspx) or Apples [Time Capsule](http://www.apple.com/timecapsule/) / [Time Machine](http://www.apple.com/macosx/features/timemachine.html) setups, but neither is quite what I was looking for. First off, I don’t really want a Windows box in (mostly) mac home, so that’s out. Time Machine alone doesn’t do everything I have in mind, although it does play an important part. I’ve had a lot of backup plans in the past, but none were quite “perfect”, which got me wondering what a perfect backup plan would look like.

### What do you want in backup plan?

Just like in creating software, when setting up a backup plan it’s important to know your requirements ahead of time. Otherwise what are you working towards? So what do I want this backup plan to be able to do…

-   Make it so that there is no single point of failure for any important data
-   Have on site and off site backups of everything
-   Backup and sync core data between macs (settings, address book, calendar, keychain, etc)
-   Some kind revision system for all text files. Something like git or svn where you can rollback changes
-   A local redundant hard drive array to guarantee no data loss if a single drive fails
-   Backup all core documents on various time intervals (daily, weekly, monthly). That way if I mess up a file and don’t realize it for a week I’ll be able to grab the version a month ago.

### Settings, Calendars, Address Book and more

If you have multiple Macs [Mobile Me](http://www.apple.com/mobileme/) is a good choice for easy syncing between macs. The system has had a lot of problems, and continues to struggle with performance. iDisk, the webdav interface to your MobileMe account is *painfully* slow, and continues to be. Just cleaning out a few hundred empty folders was enough to stall it earlier. The online image gallery MobileMe has is one of the better one’s seen, and if you use iPhoto it’s a convenient photo storage location. Just so that all my calendars and contacts aren’t confined to a single system (the Mac ecosystem), I use [Spanning Sync](http://spanningsync.com/) to keep my Google Calendars and Google Contacts in check with iCal and Address Book. My girlfriend and I share calendars with each other on Google, and this way any changes she makes show up on my iCal, and any I make on iCal show up on hers. Also, whenever I get Google Calendar invites to my email address, they show up on Google Calendar then get syncd back to iCal. 2 way syncing is the way to go!

### Complete Backups With Time Machine

Time Capsule is powerful and dead simple for full system backups. The way it works is simple: all macs on a network will have Time Machine (a program that ships with Leopard) enabled and set to use the Time Capsule hardware. Every hour or so, changes made to the core and specific folders will be pushed from the client computer (in this case my laptop) to the Time Capsule. You can specify which folders to watch for this as well. You might not want it watching your Downloads folder or others that are similarly volatile, but that’s easy to change. The first time you back up everything to Time Capsule you’ll want a hardline to it rather than doing it over a home network (even if it’s wireless N). Transferring your entire computer initially could take a full day if not, so be sure to plug it in. The hourly backups after that work wirelessly though, as they are much much smaller. Apple’s Airport Extreme has the ability to add a remote hard drive which can serve as a Time Machine drive as well. The nice part about this is that you can use an old external hard drive you have, or choose any drive out there. Leopard didn’t originally allow you to sync with drives like this, but in one of the recent updates it was enabled. For me, after the initial backup the incremental backups are very quick if not much has changed. Running TimeMachine for the first time is a trippy experience. You “go back in time” to the point where you want to see a file, then you can restore it. This covers a few of the requirements such as versioned files locally and full system backups with the ability to restore on any Mac.

### Backups to a local RAID (or Drobo)

Finally, the first step that the Media Center can help with. Whether you go with RAID, a [Drobo](http://www.drobo.com/) or something else, the backup procedure to it will be about the same. The easiest way I’ve found to do backups to this is with rsync and crontab. Here’s how it works: Your media server will have a series of scripts setup to run daily, weekly and monthly. These scripts will do all the heavy lifting of the backup - grabbing files from every computer on your network you want to backup and moving them to the redundant array. So firstoff the media server should be setup to backup everything from the computers on the network. That’s easy actually. On each computer you want to back files up from, go into System Preferences &gt; Sharing and enable “Remote Login”. This will allow the media center to ssh into each laptop. Backing up using rsync can be done by mapping drives in Finder and using those paths (/Volumes/adam), or by using SSH. With SSH you don’t have to map the drive beforehand, so it is the preferred method. On the media center, open up a text file. This will contain everything you want to copy from your client computers, and the path (on your media center) that you want to store them in.

```bash
rsync -aE --delete adam@link.local:Desktop /Volumes/Drobo/Users/adam/current
rsync -aE --delete adam@link.local:Documents /Volumes/Drobo/Users/adam/current
rsync -aE --delete adam@link.local:Movies /Volumes/Drobo/Users/adam/current
rsync -aE --delete adam@link.local:Pictures /Volumes/Drobo/Users/adam/current
rsync -aE --delete adam@link.local:Processing /Volumes/Drobo/Users/adam/current
rsync -aE --delete adam@link.local:Sites /Volumes/Drobo/Users/adam/current
```

Note that the destination (the 2nd path) is the same. That’s just because it’ll actually store the documents folder in “/Volumes/Drobo/Users/adam/current/Documents”. The- a option specifies “Archive”, which is actually shorthand for a few other options. It will recusively copy all directories, copy symlinks, preserve file permissions, preserve owner and groups, preserve file times preserve special files. The \\~~E flag preserves executability, while \\~~\\~~delete deletes extraneous files \\~~ like those that were deleted. Save this file somewhere on the media center as a .command file. I kept it simple - backup.command. You should be able to run this script by just double clicking on it now. But there is a one major problem — authentication.

### Setting up SSH keys

By setting up SSH Keys you can automate the authentication from the Media Server to any clients you want to backup. The way you do this is very easy. On the Media server, run the command @ ssh-keygen- t dsa@ . Go with the defaults, but choose a passphrase you can remember. Copy this file from the Media server to the computer you want to backup FROM. Since you should already have SSH setup, something like this should do the job.

```bash
link:~ adam$ scp ~/.ssh/id_dsa.pub adam@link.local:~/.ssh/authorized_keys2@
```

If you already have an `authorized_keys2` file, you’ll want to add the contents of `id_dsa.pub` to it instead of replacing it. After that’s updated, try SSHing to that client from the Media Server. You should get prompted for the passphrase (a mac prompt, not a terminal prompt). After you enter it and save it for later you should be able to SSH without any password going forward.

### Setting it up to run automatically

Not worrying about backups is the whole point of this entire system, so running it automatically is essential. Luckily Unix systems have an easy way of doing this using cron jobs. To open up the list of cron jobs, just enter `crontab -e` in a terminal window. This will open up the cron file using VI. Editing in VI can be a bit annoying without knowing the comamnds. To edit it you don’t need to know much VI though. Just hit “i” to go into insert mode, where you can start typing. Each line you enter is a single scheduled cron job with a very specific format. For example, here’s a line to run a script every day at 3:30am:

```bash
30 3 * sh ~/Dropbox/scripts/backup.command
```

The “30 3 *” part deals with when it should be run, while the part after that is what to run. Here’s what those first 5 options translate to:

-   30- minute to run job on
-   3 - hour to run job on
-   * - Day of the month to run job on
-   * - Which month to run job on
-   * - Which day of the week to run the job on

It’s a bit tricky to remember at first, but it’s a very simple scheduling system. For example, if you want to run something on sunday (the 0th day of the week) at 5:30 am, the parameters would be “30 5 0 …”. Here’s my full crontab that I’m using (some of these scripts I haven’t discussed yet, but we’ll get to later).

```bash
30 3 * sh ~/Dropbox/scripts/backup.command
00 5 1 sh ~/Dropbox/scripts/weekly.command
00 6 1 sh ~/Dropbox/scripts/monthly.command
30 6 1 sh ~/Dropbox/scripts/external.backup.command
```

The weekly and monthly scripts will just take a snapshot every month rather than every day. Nothing much to those scripts — just removing the last update and copying a snapshot. The monthly script is exactly the same but with “weekly” changed to “monthly”. The point of this is that if anything big goes wrong, you’ll have a backup locally of the original.

```bash
rm -rf /Volumes/Drobo/Users/adam/weekly/ cp- pR /Volumes/Drobo/Users/adam/current/ /Volumes/Drobo/Users/adam/weekly/
```

### Versioned changes with Dropbox

[DropBox](https://www.getdropbox.com/referrals/NTY0ODEwOQ) is probably my favorite part of all this. After signing up for DropBox, you install a small program on each computer you want to use it with. It’ll create a DropBox folder at a location you pick (I went with the default ~/Dropbox). Anything you add to this folder will get synced up to the Dropbox service. What’s extra-useful about this is that all files will be versioned. I’m storing my Documents and Sites folders in here and backing up daily. Even if I haven’t committed site changes for something I’m working on, it’ll still have a daily revision of changes. I have a few other commands in my backup.command file that copy things over to a DropBox folder on the Media Server.

```bash
rsync -aE --delete /Volumes/Drobo/Users/adam/current/Documents ~/Dropbox
rsync- aE --delete /Volumes/Drobo/Users/adam/current/Sites ~/Dropbox
```

One really nice part about Dropbox’s desktop client is that you can limit the upload speed. With RoadRunner my upstream is capped to about 70k/s when it’s in a good mood, and maxing it out will usually slow down any downloads. Being able to cap it to 10k/s is very useful in my situation.

### Backing up your backup scripts

You’ll notice that my backup scripts where in my Dropbox: `~/Dropbox/scripts/backup.command` . Not only does this mean that you’ve backed up your scripts (always a good practice), but you can change your backup procedure from anywhere you can access Dropbox! This is so simple it’s one of the most effortless things to setup. You can also copy the contents of your crontab file Add this line to your crontab: `@daily crontab- l > ~/Dropbox/crontab.txt` “@daily” is shorthand for “everyday at midnight”. This is a nice way of archiving any changes you make to your crontab. With the other backup scripts you can make changes on any computer and the Media Center will pull them in thanks to DropBox. But for the crontab you’ll actually want to make changes directly to the Media Center using the “crontab -e” command.

### External backups of everything else

[DropBox](https://www.getdropbox.com/referrals/NTY0ODEwOQ) is free up to 2GB making it excellent for documents, but not very realistic for media. They do offer a plan up to 50GB for $99/yr, which blows MobileMe’s 20GB plan out of the water. Most the use I get from MobileMe is in syncing computers though, so I’ll keep it going for that. For now I’ll stick with MobileMe for my larger media backup as well, although I can tell you now I’m not exactly happy about it. One of the downsides of MobileMe is that it doesn’t automatically mount itself on startup. Normally you have to click on it in Finder to mount the drive. Only then it’ll show in “/Volumes”. You can open up Script Editor and create a small app to do this though. Just copy this and change it to use your username and password. @ tell application “Finder” mount volume “http://idisk.mac.com/myusername/” as user name “myusername” with password “mypassword” end tell @ Save it as file format “Application” with “Run Only” checked, but don’t check “Stay Open” or “Startup Screen”. Save this application somewhere then add it to your startup items. The last part is setting up the “remote.command” script listed earlier. This will do all the work of copying everything remotely, with the exception of whatever uses Dropbox.

```bash
rsync -aE --delete /Volumes/Drobo/Users/adam/current/Documents /Volumes/myusername
rsync -aE --delete /Volumes/Drobo/Users/adam/current/Backup /Volumes/myusername
rsync -aE --delete /Volumes/Drobo/Users/adam/current/Desktop /Volumes/myusername/Documents
rsync -aE --delete /Volumes/Drobo/Users/adam/current/Movies /Volumes/myusername
rsync -aE --delete /Volumes/Drobo/Users/adam/current/Pictures /Volumes/myusername
rsync -aE --delete /Volumes/Drobo/Users/adam/current/Sites /Volumes/myusername
rsync -aE --delete /Volumes/Drobo/Books /Volumes/myusername/Documents
```

This just runs weekly everything here doesn’t change that much. The Pictures directly is the main one that’ll be updated, as it’s a single iPhoto file that changes often.

### Woh, that’s a lot. Did we miss anything?

Well, two things were skipped- - Music and Videos. I have a decent sized music collection, and I tend to archive my DVDs for use with Plex. Backing up 2TB of data remotely when you’re limited to 70k/s upload speeds isn’t exactly possible. What I am doing is storing all my media on a Drobo which protects it against a single hard drive failure (maybe more, depending on when the failures occur). My TimeMachine drive is actually a 500gb drive split - 200 for Time Machine and the rest for media backup. Every night the Media Center pushes all music from the Drobo onto this external drive. At least that way all my music is protected in case the Drobo itself fails. There’s no external backup for music, but I’m OK with that. If I was a little more paranoid I might archive weekly and leave the drive at work or something, but that’s where I draw the line. That leaves one gaping hole - the movie collection this system was for in the first place! For now I’m content with being protected against a single HD failure with the Drobo, but if anyone has any suggestions on how to back this up I’m all ears. Also if you think of anything else I missed, or just something I could do better then please leave a comment!

### Did this help?

If this article helped you, please sign up for [DropBox](https://www.getdropbox.com/referrals/NTY0ODEwOQ) ! DropBox was in beta for a while, but now it’s open and anyone can sign up. You get 2GB of space just for signing up. They have the added bonus of increasing your space by 250mb for everyone you refer (up to 5GB total), so by signing up you’ll give me more space to experiment with. It’s easily the best backup service I’ve used, so I’m looking forward to seeing how it grows.
