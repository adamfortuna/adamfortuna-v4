---
title: Getting Started With Ember.js and Firebase
date: 2014-01-08 14:03
permalink: emberjs-and-firebase
tags: Technical, Javascript
---

About 6 months ago I started learning Ember.js. The first few months I was spent reading the [Ember.js Guides](http://emberjs.com/guides/) (which are amazing by the day), and going through every screencast I could find. We had some Ember projects at work, but the main reason for learning it was to overcome some of the limitations and code clutter that was starting to present itself in more advanced Backbone.js applications.

@pull left
![Warming Up With Ember.js](http://localhost:4000/galleries/codeschool/ember.png){: .icon}
@

Eventually, I lucked into being able to write the content of Code Schools December course, [Warming Up With Ember.js](https://www.codeschool.com/courses/warming-up-with-emberjs). In writing the content, I became very familiar with the core fundamentals of an Ember.js Application, but still hadn't built one that used any kind of server component.

## Ember Reading List

@pull right
Please make a JS API Goodreads!
@

Ideally, I wanted to build something that I could use to show what I've been reading on my personal site by using the [Goodreads](https://www.goodreads.com/) API. Unfortunately, Goodreads only has a server side API with a private access key, so that was out. Turns out I'd need to either have a server side component that translates their API into an API I could use, or access a remote database directly.

## Firebase

@pull left
![Firebase](http://localhost:4000/galleries/logos/firebase.png){: .icon}
@

That's where [Firebase](https://www.firebase.com/) comes in. Firebase advertises itself first and foremost as an API for building realtime applications. For my use case that's not important, but what is important is covered nicely by Firebase.

* Use as a database directly from an Ember.js application
* Allow user authentication - in my case I'm using GitHub for auth
* Restrict writing to the database to only logged in users, or in my case, just me
* Plays well with Ember.js

The security controls in Firebase go deeper than a simple yes/no. You can control it down to a column level in a database with data validations.

### HTML Setup

Lot of libraries to include. You'll need the usual Ember dependencies: jQuery, Handlebars and Ember itself. Next, you'll want to include Firebase and EmberFire. For authentication, you'll need one of the Firebase login scripts.

```html
<script src="//code.jquery.com/jquery-2.0.3.min.js"></script>
<script src="//cdn.firebase.com/v0/firebase.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.2.1/handlebars.min.js"></script>
<script src="http://builds.emberjs.com/canary/ember.min.js"></script>
<script src="//firebase.github.io/emberFire/emberfire-latest.js"></script>
<script src='//cdn.firebase.com/v0/firebase-simple-login.js'></script>
```

### JavaScript Setup

After creating an account on Firebase, create a new Firebase. The URL that you receive with it will be the endpoint which represents your database.

In the model function of your `Route` object, you can load up some data from Firebase. In the following example, we're loading up an array of book objects stored at the `/books` endpoint of our database.

```javascript
var firebaseURL = ;

App.BooksRoute = Ember.Route.extend({
  model: function() {
    return EmberFire.Array.create({
      ref: new Firebase("https://booklist-ember.firebaseio.com/books")
    });
  }
});
```

This will return a promise, the same way that Ember Data does when it loads your records from fixtures or a REST API. The resulting model in this case will be an array of JavaScript objects for each book stored at that location.


### Creating Records

Maybe I should back up a bit here. That example was a little easy for showing the consumption side, but what about the creation side?

Every object in Firebase has an endpoing it can be accessed at. In the case above, we were looking at the `/books` endpoint which is being treated as an array of books. If we wanted to add a book, we could push a new book into this array as well:


```javascript
App.BooksNewRoute = Ember.Route.extend({
  model: function() {
    return EmberFire.Array.create({
      ref: new Firebase("https://booklist-ember.firebaseio.com/books")
    });
  }
});
App.BooksNewController = Ember.ObjectController.extend({
  actions: {
    createBook: function() {
      this.get('model').pushObject({
        title: this.get('title'),
        author: this.get('author'),
        rating: this.get('rating'),
        review: this.get('review'),
        amazonId: this.get('amazonId')
      });
      this.transitionToRoute('books');
    }
  }
});
```



### Authentication

```javascript
{
  "rules": {
    ".read": true,
    ".write": "auth != null && !data.exists()"
  }
}
```
