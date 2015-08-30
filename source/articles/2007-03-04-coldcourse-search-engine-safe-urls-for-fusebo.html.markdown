---
title: "ColdCourse: Search Engine Safe URLs for Fusebox, Mach-II, Model-Glue and ColdBox"
permalink: coldcourse-search-engine-safe-urls-for-fusebox
tags: Technical, ColdFusion
---

One thing that's always been left out of ColdFusion frameworks (with the exception of ColdFusion On Wheels) is URL handling. This is a big thing. It's not essential for making an application, and it certainly can be a time drain to get URLs just right. Ruby on Rails started a trend in controlling URLs not through URL rewriting, but more tightly bundled into the framework. ColdFusion on Wheels did this too, although it didn't get that much attention for what was one of the most amazing innovation of any CF framework I'd seen in a while.

So what is ColdCourse? ColdCourse is a framework agnostic routing system that will execute *before* the framework. You know that index.cfm file that you're never supposed to touch? Well this is a modification to that. Before the request hits your framework, ColdCourse will translate the URL into the URL variables you're expecting, and set them back to the URL scope. Here's an example: <http://localhost/index.cfm?fuseaction=home.main> Would be the same as… <http://localhost/home/main> In the configuration file for ColdCourse you setup a few things to identify the framework you're using, such as what the event variable should be (fuseaction, event), what the separator should be (it's always a period for Fusebox and ColdBox, but you could be using anything for Mach-II or Model-Glue), what the default action should be if you don't include an action and more.

You're probably thinking that with Mach-II and Model-Glue you really don't have to have URLs that are in the form “controller.action”. Well you're right. In order to use ColdCourse though, you'll need to follow a convention where every single event in your framework has exactly one controller and exactly one action. I think you could also make it work if you have all single world actions as well by setting the separator to “” and the action to “”, but I have not yet tested that out, and you would be unable to use ANY controller/action pairs.

### Default Actions

Don't let all this controller/action talk make you think that all URLs must contain both. There are quite a few ways to tweak the URLs to do what you want. The easiest way is through the FrameworkActionDefault set in the config file. Lets say you default this to “index”, then when you go a URL that only sets the controller, this will be automatically set as the action. For instance: <http://localhost/home/index> would be the same as <http://localhost/home> .

### Unique URLs

With all these different URLs flying around there's a chance a search engine might pick up both those, or even worse- - 3! You probably don't want Google deciding which of these URLs is your REAL URL, so ColdCourse handles that. For instance, if someone goes to that initial URL we mentioned, <http://localhost/index.cfm?fuseaction=home.main> , ColdCourse will issue a 301, permanently moved header response and using a header location redirect them to <http://localhost/home/main> . Also, if a user goes to <http://localhost/home/index> they will get redirected to <http://localhost/home> in the same way.

### Gotchas

Nothing is perfect! This is the first attempt at this, and although I know the CF On Wheels portion to be tested by quite a few people, my code has not been. As far as implementing this in your own project, there are a few things to watch out for. If you're using any kind of “self” or “myself” variable, chances are it has the framework specific values in there. These can be updated in a prefuseaction or an onrequeststart method in your framework and set to “” in order to make things easier.

If you want to test things out NOW without changing much code, you might want to change whatever variable contains “index.cfm” and change it to “/index.cfm”. Those paths really start to get hairy if you're trying to do a little in both worlds though, so I'd recommend either going all out or none at all. You're probably setting your XFAs as “controller.action” as well too, which may need to be refactored into “/controller/action/”. URL variables and FORM variables passed to non-Coldcourse URLs will be forwarded over to the ColdCourse URL. For forms this a VERY bad idea if you're doing anything sensitive, and just a BAD idea if you're not. It'll also mess things up if you need to know what's in the form scope and url scope. I think all frameworks covered will just squish these into a single scope though, so although the end result is the same, be sure to fix forms to go to the new URLs if you do nothing else.

### What You Need

Just like the routing in COW, you'll need either a webhost that supports .htaccess files (apache), or access to IIS to install an Isapi filter. Other than that you really only need to be able to run CFCs. This hasn't been tested on other versions besides CF7, but should work in theory on any 6.1+ style CFML processor.

### Installation

Installation is a two second process if you're on apache, but will be a little more trouble if you're running IIS. For IIS, you'll have to get [Isapi Rewrite](http://www.isapirewrite.com/) working and include the packaged ini file. For Apache you just drop the .htaccess file in your root dir. Other than that just place your config file, Coldcourse.cfc and coldcourse.cfm wherever you want. By default these will go in /config, /model and /, respectively, but can go anywhere if you change their paths in coldcourse.cfm. Next you can setup your framework specific settings and some courses in the config file.

### Credits

To be honest, all the hard work for this came from the [CF On Wheels](http://www.cfwheels.com/) guys, Rob Cameron & Per Djurner for making the routing system used there. This is just an adaptation of their code to work with other frameworks. **Download** You can grab it now on Riaforge at <http://coldcourse.riaforge.org/> .
