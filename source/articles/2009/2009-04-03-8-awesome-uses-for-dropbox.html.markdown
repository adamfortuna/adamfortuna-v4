---
title: "8 Awesome Uses for DropBox"
permalink: 8-awesome-uses-for-dropbox
published: true
tags: Personal
---

Although only a very small part of my "backup strategies":http://www.adamfortuna.com/2009/03/22/building-the-ultimate-media-center-part-3-backup/ post dealt with "Dropbox":https://www.getdropbox.com/referrals/NTY0ODEwOQ , after using it for a second week I've fallen for it. Sure, it's useful for syncing commonly used files between computers, and there's many more files that it would be useful to have revision history on, but there's more to it than just sharing files. With that in mind I've been on a rampage to use it for simplifying my life as much as possible. Here's a few tricks I've found that help make things easier.

### Backup Folders Not in Dropbox

Right now Dropbox installs itself into a pre-selected location, then everything in that folder is archived in Dropbox. Syncing outside of the Dropbox folder is on the todo list, but for now there's a workaround to do this. Create a symbolic link within the Dropbox folder pointing to the folder you want to archive. For instance, lets say within Dropbox you want your Documents folder. To do this you'd create a sym link for this.

```bash
ln- s ~/Documents/ ~/Dropbox/Documents
```

Dropbox should start syncing right away, and will sync from here on out whenever. Anything that goes into your @~/Documents@ folder will be backed up. One very important thing to note is that if you delete something from the @~/Dropbox/Documents@ folder on another computer, it will be removed from your @~/Documents@ folder on the computer with the symlink, so keep that in mind.

### Syncing Adium Log Files Between Macs

So you're looking through chat logs for a conversation you know you had, but you can't seem to find it. Turns out it was on a a different computer. Has this ever happened to you? There's a convenient way of syncing Adium log files (or any other log files) with Dropbox. Adium doesn't allow you to change your Log directory, but there's no reason why you can't make the default location a smylink to somewhere else. I have a @~/Dropbox/Sync@ directory where I store any settings/items that I want to keep in Sync between computers, so this is the perfect place for it. I created a @~/Dropbox/Sync/chat@ folder, quit Adium and dragged my existing Adium logs folder into Dropbox (from /Users/adam/Library/Application Support/Adium 2.0/Users/Default/Logs). All you have to do is point a folder at your Dropbox and you're good to go! In my case, the command was:

```bash
ln -s ~/Dropbox/Sync/chat/logs/ "/Users/adam/Library/Application Support/Adium 2.0/Users/Default/Logs"
```

Just setup multiple computers with this same path and you should have a single repository for all your chat logs. I'm not too sure how this works with conflict resolution, but unless you're chatting to the same person on multiple computers at the same time you should be good. If you've tried that though, I'd be interested to see how it works.

### Backup configuration

This was mentioned earlier, but having a shared space for your backup scripts makes life easier. Dropbox is amazing, but the Dropbox application does have the ability to delete files from your computer. Lets say the worst happens and they delete your account, causing your Dropbox to be deleted on all your computers- - would you mind? If you have your ~/Documents and other folders linked, this might be a huge blow to lose unless you're backing it up somewhere. This same doomsday scenerio could happen if someone hacks into your Dropbox account and removes your files from the web interface. You'll probably be able to restore them in that case, but then you're relying on Dropbox to fix the Dropbox problem. A more secure way of handling this might be to have a full copy of your Dropbox somewhere locally. With Dropbox maxing out around 55GB, making a full copy of this on some HD you have laying around isn't a bad idea. Automating the process and backing up your Dropbox nightly is even better though! So what would something like this look like.

```bash
rsync -rpLtgoDE- -delete ~/Dropbox /Volumes/Drobo/Users/adam/current
```

This rsync command will copy everything from my Dropbox to a local directory, in this case on a "Drobo":http://www.drobo.com/ . This follow all symlinks and copy the contents of them, rather than copying the symlinks themselves. Try saving this one line in a file, @backup.command@ . You should be able to run it by double clicking or from terminal. I store this file in @~/Dropbox/Sync/scripts/backup.command@ so it can be edited from anywhere.

### Version your crontab

You don't want to run that backup script manually everyday do you? To save time (and guarantee a good backup strategy), you'll want to have this automatically run. I'll recap real quick how to set this up. Just open up terminal on the computer you'll be automating the backup. You can call things on a scheduling using "cron":http://en.wikipedia.org/wiki/Cron , which can be opened by entering @crontab- e@ . I've decided to run the above script every day, and backup my list of cron jobs every day.

```bash
@daily crontab -l > ~/Dropbox/Sync/scripts/crontab.txt 30 3 * sh ~/Dropbox/Sync/scripts/backup.command
```

The first line will save the crontab contents in the @ ~/Dropbox/Sync/scripts/crontab.txt@ file. The @daily parts means this'll happen every night at midnight. The second line is scheduled to run every night at 3:30am as well, but usually takes a little longer. Rsync isn't the fastest in the world, but it'll get the job done- - usually in under a minute for me.

### Sync Your "Things":http://culturedcode.com/things/ Tasks

For a while during the beta, Things was my GTD/todo list of choice. The interface has a level of polish that few apps obtain -- and even fewer in the GTD relm where complexity is the norm. One downside of Things is that it doesn't use MobileMe syncing like OmniFocus, it's competitor. You can get around this and use your Dropbox for syncing in the same way as Adium though. Just close Things and move your Things database files folder to your Dropbox on one computer -- I threw it in ~/Dropbox/Sync/Things. Create a symlink from where it used to be to the new Dropbox location and you should be good! You'll need to do this same step on your other computer(s), but without the copying the file to Dropbox step. This does have a caviat though -- you must close Things each time you switch computers. Unlike Adium, when there's a conflict, well it's very bad. Your Things database is a single XML file that cannot be merged. So be sure to always close Things when you switch computers to be safe. If anything goes wrong though, you can always sign into the Dropbox web interface and roll the file back. Or you could just use "Remember the Milk":http://www.rememberthemilk.com and not have to worry about syncing.

### Host a Local Wiki

"TiddlyWiki":http://www.tiddlywiki.com/ is a Wiki unlike any other I've heard of. It has all the storage characteristics of a normal wiki, but exists as a single html file that edits. Just copy it to your Dropbox, open it up in Firefox (you are using FireFox right?) and start making changes. Upon saving it'll update the file in Dropbox. As with a few other tips, you probably shouldn't have TiddlyWiki open on another when saving. If you've jumped on the TiddlyWiki bandwagon but you're using a USB drive to transfer your Wiki around, Dropbox is a simple upgrade to save some time.

### Sync your Passwords

I don't personally use any sort of password manager, but LifeHacker has a good article on "How to Use Dropbox as the Ultimate Password Syncer":http://lifehacker.com/5063176/how-to-use-dropbox-as-the-ultimate-password-syncer . According to the Lifehacker article, changes are pulled in right away, even when using multiple computers. This is because 1Password, the password manager used in the article, stores your data in lots of little files, making it ideal for minimal conflicts.

### Sync your Firefox Bookmarks

Firefox bookmarks are another one that seem like a no-brainer to use Dropbox for. There are so many different bookmark sync services out there that can do this, but why use another service when you're already using Dropbox? The basics for this are just copying your firefox profile to Dropbox, then starting Firefox with the- p option which allows you to specify a profile path. Just follow the directions on how to "Sync Firefox Bookmarks":http://wiki.getdropbox.com/TipsAndTricks/SyncFirefoxBookmarks from the Dropbox Wiki and you should be good. This tip doesn't use symlinks like a number of others, making it a little easier to setup.

### Join Dropbox

Dropbox provides 2gb of storage out of the gate, but if you signup with a "referral link":https://www.getdropbox.com/referrals/NTY0ODEwOQ , you'll get an extra 250mb of space (and I'll get an extra 250mb too)! The desktop app works on Mac, PC and Linux with a very simple install on all of them. If you join up and have any other tips or tricks, feel free to share them here!
