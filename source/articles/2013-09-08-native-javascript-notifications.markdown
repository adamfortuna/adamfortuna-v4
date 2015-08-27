---
title: Native Notifications with JavaScript
description: Using HTML 5 native notifications with JavaScript in Chome, Safari, Firefox and on Windows.
date: 2013-09-08 23:42
permalink: native-javascript-notifications
tags: Technical, JavaScript, Code School
---

In browser notifications have made a lot of progress in the last few years. Hell, native notifications have made a lot of progress in that time too. Just a few years ago, everyone on the Mac was using [Growl](http://growl.info/). With the release of Mac OS X 10.8 (Mountain Lion) the one purpose of Growl was now built in and everyone I know made the switch to using native notifications.

@pull left
Warning: Link to the official spec.
@

Notifications caught on with Mac App developers. [HTML 5 Notifications](http://notifications.spec.whatwg.org/) have had a slower growth curve as the various browsers focus in on a single standard. As of this writing, here's a recap of where the different browsers stand when it comes to supporting notifications.

OS X Mavericks has expanded support for notifications that builds heavily on this. Here's what's public on the topic so far:

> Once users have signed up for notifications from your website in Safari, you can send them push notifications that appear just like app notifications, even when Safari isn’t running. Users can then click on your push notification to launch your website.
<a href='https://developer.apple.com/osx/whats-new/'>OS X Mavericks for Developers</a>

In other words, it's time to hop on board the notification train if you want another route of reaching your sites visitors. Let's check out how this applies to the different browsers.

## Common Traits

@pull right
Read the source from this project to understand how browsers implement notifications
@

The major browsers (setting aside IE) have a few patterns in common right now that we can use to style our behavior pattern around. If you want see how to use notifications in different browsers, check out the [HTML5 Desktop Notifications](https://github.com/ttsvetko/HTML5-Desktop-Notifications/) project on GitHub. It's worth reading over the source code.

## Request Permission

In order to send notifications in all browsers, you'll need to request permission to do so. In that very long spec, there are 3 permission levels noted:

* `default` - No permission granted or denied
* `granted` - The user has granted permission to send notifications
* `denied` - The user has denied permission

If permission is denied you won't be able to request permission again in the current session. If you try to send a notification without having been granted permission, nothing will happen.

## Send A Message

Once you have permission, you'll be able send down a notification with the following attributes:

* `title` - Should be short and to the point
* `body` - You'll have a bit more room to work with here. Unfortunately, in Safari this will be truncated
* `icon` - In Chrome and Firefox, you can send over whatever icon you want. This isn't being served by Notification Center, so there is more flexibility here.

When the message is shown, there are also a few events that we can tie into for added flexibility:

* `onshow` - When the notification is first shown.
* `onclick` -  When the user clicks on the notification. By default this will bring the window into focus.
* `onclose` - When the notification is closed, either by the user or programatically.
* `onerror` - Trigger if the notification cannot be presented to the user

Here's a few examples of how these notifications look in different browsers.

@pull left
![Safari](http://localhost:4000/galleries/icons/safari.png){: .icon}
@

### Safari

For Safari notifications, you won't be able to provide an icon unfortunately. Instead it'll always use the Safari icon. It will also show the hostname where the notification came from though, which is unique to Safari.

![Safari Notification](http://localhost:4000/galleries/articles/native-javascript-notifications/safari-notification-small.png)

One of the nice parts of this notification is that it will sync up with your other notifications. For instance, if you have one notification from Xcode and another from a website, they'll show up stacked rather than on top of each other.

### Mavericks

Not exactly a JavaScript implementation, but worth noting that notifications in Mavericks behave much differently than HTML 5 notifications. They more closely resemble iOS notifications, where you're pushing to Apple's servers, and they're pushing to the end user.

![Mavericks Notification](http://localhost:4000/galleries/articles/native-javascript-notifications/mavericks-notification-small.png)

The addition of a custom icon here is definitely a plus. This alert is from a [Safari Push Notification Demo](http://kandutech.net/) which should only work if you're running Safari in Mavericks. If you clicked on that alert, you'd get taken to a page that describes how it works:

> When you allowed this website to send you push notifications, we generated a 4 digit code and put it in a database along with your Mac's push token. When a push notification is triggered through our servers, we resolve the 4 digit code to your Mac's token. Once we have your token, we tell Apple's servers what the notification should look like, and where it should go. Apple's push notification service then delivers the notification we generated to your Mac.
<a href='http://kandutech.net/clicked'>Safari Push Notification Demo</a>


@pull left
![Chrome](http://localhost:4000/galleries/icons/chrome.png){: .icon}
@

### Chrome

Chrome notifications show up square, which stands out from the rounded look of OS X and Firefox notifications. It also shows up larger in all dimensions

@pull right
Chromes notifications are significantly larger than Notification Center.
@

![Chrome Notification](http://localhost:4000/galleries/articles/native-javascript-notifications/chrome-notification-small.png)

Unlike Safari notifications, this will stay up until it is dismissed.

@pull left
![Firefox](http://localhost:4000/galleries/icons/firefox.png){: .icon}
@

### Firefox

The Firefox notification would be prettiest out of the box, but the entire body is shown as a link! For all notifications, clicking on it takes you to the page, but Firefox attempts to make it more apparent. The appearance ends up suffering due to this choice.

@pull right
Why is the body a link Firefox? WHY?
@

![Firefox Notification](http://localhost:4000/galleries/articles/native-javascript-notifications/firefox-notification-small.png)

@pull left
![Chrome](http://localhost:4000/galleries/icons/ie.png){: .icon}
@

### Windows

While there are no system level notifications in Windows (I don't think?), but Internet Explorer 9 and up allow you to add an icon overlay on the browsers icon. This allows for some feedback in this browser. You can see an example of this in the Readme for the HTML5 Desktop Notification project on GitHub.

Chrome and Firefox on Windows support notifications that behave similar to their Mac counterparts.

## Demo

Want to see how notifications look in your browser? Try out the [HTML5 Notifications Demo](http://ttsvetko.github.io/HTML5-Desktop-Notifications/) to find out.

## Update

For an example of how this technique is used, read the post on [Teaching iOS 7 at Code School](/2013/10/04/teaching-ios-7-at-codeschool/). This post details the user experience that can be achieved using native browser notifications.

## Credits

1. Icons for Safari, Chrome and Firefox by [Stefano Tirloni](http://dribbble.com/shots/1032875-Flat-Icons).
2. Internet Explorer Icon by [1 Little Designer](http://onelittledesigner.com/rapidweaver/web-icons/free-flat-browser-icons/).
