---
title: "Snow Leopard Upgrade Not Always Smooth"
permalink: snow-leopard-upgrade-not-always-smooth
tags: Technical, Short
---


After reading post after post of smooth upgrades from Leopard to Snow Leopard, I felt more obliged to share my not-so-successful upgrade story. You must remember, if you've been using your computer a while, there's a much greater chance that there's a problem with it, and that installing a very large enhancement on top of that possibly fragile groundwork might cause issues. Make sure you have some backups (you use [Dropbox](http://adamfortuna.com/2009/04/02/8-awesome-uses-for-dropbox/) right?), and that you do a full system save using TimeMachine prior to starting.

### What Actually Happened

Insert disc, go through install. Apple products have easy installs right? No doubt there- within a minute it was already copying files over and doing it's thing. Unfortunately it hit a very odd error "Unable to complete upgrade" with an option to restart. OK, time to restart. Booting up was when the problem hit me though. I saw the normal gray loading screen with the spinner, but it went from that to a complete black screen and turn off. Not a good start.

After trying this a few times, I eventually tried holding `option` on boot, which brings up a boot menu allowing you to select which device to boot from. With the Snow Leopard DVD still in the drive, I choose to boot from it. It made it to the install window again, and again I gave installing a shot (although much more pessimistic this time). Again it failed, but it suggested I run Disk Utility to verify my drives. Ok, good advice. Luckily you can run these straight from the installer (there's the default menu bar up top with a "utilities" menu with "Disk Utilities" as one of these. This is the same program you should have available through Leopard. I select my drive, click verify and within a few minutes I see a big red flashing error message that says my drive is corrupt and that I should back everything up using TimeMachine, format and recover an install from TimeMachine.

That's when I realized my first mistake - **not verifying the health of my drives before upgrading my OS** . Rather than reinstalling Leopard and upgrading to Snow Leopard, I opted for a complete hard drive format, then installed Leopard on that. It didn't seem to have a problem installing everything, which was quite a relief. When you think ‘upgrade' you don't think you'd be able to get doing from a formatted disk, but luckily Snow Leopard didn't have a problem with this.

Eventually I had a completely clean install of Snow Leopard on a newly formatted drive. At this time if you have a clean TimeMachine backup you can use it as a starting point to import all your files/settings/passwords/etc. I decided to start from scratch (perhaps it's the lingering Windows masochist in me), and install only what I need. In not too long I had plenty installed, and didn't miss what I didn't know I was missing. The nicest part though, was that with TimeMachine you can just jump in and grab an old file from any computers backup. As someone who hasn't used TimeMachine very much over the years, it was welcomed relief to backup. Still though, I prefer Dropbox for it's ability to backup + sync files across multiple computers — but for large files it's hard to beat TimeMachine.

### What I Should've Done

Run Disk Utility first to verify disks, and repair them if you can. At least at that point you'll have one more piece of information on if your Snow Leopard install will be a complete failure or not.
