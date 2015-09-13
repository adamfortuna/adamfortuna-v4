---
title: How I Create Photo Albums
date: 2015-09-08
tags: Technical
permalink: how--i-create-photo-albums
description: A lot of work goes into each -- here's how.
---

After my [trip to Japan](/photos/japan/adam-and-marilyn-go-to-japan) I wanted some way to showcase and remember the trip. We could hang up photos around the house, or keep them around in a folder, but scrapbooking them always had a lasting effect. Scrapbooking them online seemed like it would be more long lasting (and guarantee that I'll take another look at them.)

Here's a look at the technology and organization that goes into one of these posts.

## Middleman

@pull right
To learn more, check out Drew Barontini's post on [Middleman](http://drewbarontini.com/articles/middleman/).
@

In September, 2015, I moved my blog over from [Jekyll](https://jekyllrb.com/) to [Middleman](https://middlemanapp.com/). Jekyll wasn't limiting me exactly, but with Middleman things became much, much more easy. If you enjoy working with Rails it makes sense to move over. There are amazing gems like [middleman-blog](https://middlemanapp.com/basics/blogging/) which handle everything you need to create a blog.

It also makes it easy to create __two__ blogs. In my case, there's one blog at `/articles` and another at `/photos`. Each of these blogs has their own folder, their own organization system, own layouts and more. Configuring these is super simple:

```ruby
# /articles
activate :blog do |blog|
  blog.name = 'articles'
  blog.prefix = 'articles'
  blog.permalink = '{permalink}'
  blog.sources = '{year}/{year}-{month}-{day}-{title}.html'
  blog.tag_template = 'articles/tag.html'
  blog.taglink = 'tags/{tag}'
end
page "articles/*", :layout => :article
page "articles", :layout => :layout

# /photos
activate :blog do |blog|
  blog.name = 'photos'
  blog.prefix = 'photos'
  blog.permalink = '{collection}/{permalink}'
  blog.sources = '{collection}/{year}-{month}-{day}-{title}.html'
end
page "photos/*", :layout => :photo
page "photos", :layout => :layout
```

For the `/articles` page, they're all stored in the `/articles/:year` folder, which is a lot cleaner than my previous mega-folder with every blog post. Also, there are easy pages for [technical](/articles/tags/technical) tags and [personal](/articles/tags/personal) -- amongst others.

@pull right
If you live in Orlando and like meeting new people, check out [Orlando Dinner Party Project](/photos/events/orlando-dinner-party-project).
@

For `/photos` though, they're organized by `collection` -- a term I'm using for the overall group a photoset belongs to. For instance, my [Japan](/photos/japan/adam-and-marilyn-go-to-japan) Japan post belongs to the "japan" collection. Smaller groupings like [Orlando Dinner Party Project](/photos/events/orlando-dinner-party-project) belong to an "events" collection.

This allows for easy folder structure locally, and some easy to read permalinks like [/photos/japan/tokyo](/photos/japan/tokyo).

## Frontmatter

@pull left
Not a science term.
@

One major concept of many blog systems -- both Jekyll and middleman-blog -- is the idea of frontmatter. Frontmatter is YAML code that shows up at the top of your post file before the content itself. This code has very few requirements (usually you'll want to include a title), but anything else can be included and used within your site. Here's a few things that frontmatter can be used for that I'm taking advantage of.

* **Stats** - Used to show how many photos and videos are in a post.
* **Series** - Boolean to denote if this is a multiple part post. For multi-part posts, you'll see a dropdown to navigate.
* **Children** - For photo posts that span multiple articles, I put the permalinks of the children here in the root post.
* **Parent** - Used to determine if this post should be shown on the homepage or photos page. For instance, I wouldn't show the "Tokyo" page of my Japan post by itself -- I'd only link to it as part of that collection.
* **Short Title** - Used in the dropdown on the photos page.
* **Poster** - This is a relative URL to an image to use on the homepage to link to the post.
* **Header** - Relative link to an image to show at the top of a post.
* **Disqus Identifier** - If a post was published on my previous blog, this is a great place to override the Disqus identifier so that comments are brought over with new URLs.

Here's a full sample of what this frontmatter looks like for a post.

```yml
---
title: Adam & Marilyn go to Japan
short_title: Japan
date: 2014-05-10 10:07
collection: japan
permalink: adam-and-marilyn-go-to-japan
tags: Travel
disqus_identifier: japan
stats:
  photos: 350
  videos: 11
description: Two weeks in Japan during sakura season
poster: /images/galleries/japan/ueno/resized/blossom_boats.jpg
header: /images/galleries/japan/travel/resized/rail_pass.jpg
series: true
children:
  - kyoto
  - hakone
  - tokyo
  - takeaways
---
```

Most of this frontmatter can be used in your custom Middleman templates for creating an article. Custom attributes can be accessed through `data` -- for example: `current_article.data['stats']['photos']`.

## Markdown

By default middleman-blog uses the extension of your posts filename for parsing post content. If it ends in `.markdown`, that's all the configuration you need. We love Markdown at [Code School](https://www.codeschool.com) and use it for writing pretty much all of our content. I prefer using the [Kramdown](http://kramdown.gettalong.org/) markdown parser, which is easy enough to extend. You can edit your Middleman `config.rb` to use Kramdown.

```ruby
set :markdown_engine, :kramdown
```

## HTML Markup

One issue I ran into was trying to figure out a good way to have a setup where some posts use 100% of the width of the page, but most of the content is constrained to the default width -- in my case 1170px. Because of this, I wanted the content of a post to be 100%, which meant that the entirety of the post couldn't be contained in a single `.row` element.

To get around this, I wrap each element in a wrapper element to create the grid. Here's what this looks like in practice:

```html
<section class="wrap">
  <p class="wrap--inner">This is a paragraph of text!</p>
</section>
```

At a Sass level, each `.wrap` element is basically a foundation `.row`, and each `.wrap--inner` is an element that is 8 columns, with a 2 offset (or 7 columns with a 1 offset for articles). This allows photos that are on their own line (or galleries) to take up a wider portion of the page.

### Changing the Generated HTML

In order to change the generated HTML of what it means to be a `p` tag, we have to dive a bit deeper into Middleman and how it renders an element. In this case extending `Middleman::Renderers::MiddlemanKramdownHTML` and overwriting some of the `convert_*` methods. To change what it means to be a `p` tag, we can create a method that converts a `p` tag to html:

```ruby
module Middleman
  module Renderers
    class MiddlemanKramdownHTML < ::Kramdown::Converter::Html
      def convert_p(el, indent)
        content = inner(el, indent)
        if indent == 0
          %(<section class='wrap'><p class='wrap--inner'>#{content}</p></section>)
        else
          %(<p>#{content}</p>)
        end
      end
    end
  end
end
```

The `indent` part will guarantee that if a `p` tag is at the very top level it'll be wrapped with some additional markup, but if not it will be output as a normal `p` tag.

### Styling the Wrap

Styling this element could be done any number of ways. One way would be by adding a number of CSS classes in the Ruby code to position it there. However that'd mean that I'd need a separate Markdown parser for the photos page and the articles page since both use a different number of columns for their content.

@pull right
I completely forgot about the trailing `&` method until I saw [Adam Stacoviak's post](http://thesassway.com/intermediate/referencing-parent-selectors-using-ampersand).
@

The Sass for these is relatively simple. We want the `wrap` element to behave like a `.row`, centering content and making an 1170 width area for our content. Then we want the `wrap-inner` element to take up some number of columns -- a different number for photos and articles.


```sass
@import 'foundation/components/grid'

.wrap
  @include grid-row

.wrap--inner
  // Articles take up 7 columns
  .article &
    @include grid-column($columns: 7, $offset: 2)

  // Photo posts take up 8
  .photo &
    @include grid-column($columns: 8, $offset: 2)
```

I'm relying heavily on Foundation, which has some really nice helpers to make things like this possible. Coupled with the very cool trailing `&` in Sass, this will look for elements matching `.article .wrap-inner` and make them 7 columns, while `.photo .wrap-inner` elements will get 8 columns. Very handy way to use Foundation with Markdown to make extending the site super easy.

If later on you have another type of page that's generated by Markdown, but needs a different grid system, it can be added in here.

## Galleries

Now that we have the main content taking up 8 columns in the middle, the hard part is the galleries themselves. These, of course, take the longest amount of time. Organizing the photos and laying them out takes the most time. Within the Markdown for a post, I added a shorthand for showing the gallery. For instance, if I wanted to show a gallery with images from Ueno Park in the Japan trip, I'd include this line:

```markdown
@gallery japan/ueno
```

The markdown parser will see this and create the gallery there. In order for this to work, however, you'll need to extend Markdown with a few custom features of your own.

### Adam Flavored Markdown

In order to make this happen, you have to extend Markdown. In my case, I updated my Middleman config to use AFM, or Adam Flavored Markdown:

```ruby
set :markdown, input: 'AFM'
```

By itself, this would error out unless you have a Ruby class defined with the name of `Kramdown::Parser::AFM`. I decided to inherit from `Kramdown::Parser::GFM`, a solid Markdown parser, and extend things as needed.

@pull right
Want to learn some Regex? Try Code Schools [Breaking the Ice with Regular Expressions](https://www.codeschool.com/courses/breaking-the-ice-with-regular-expressions) course!
@

I've ended up adding a few extensions to Markdown for galleries and those little pullouts to the left and right side. These work, but have been extremely hacky. The way to add them is by defining new regex patterns. If they match, the method is called. In there I'll read a `data/galleries/japan/ueno.yml` file which contains all of the information about that gallery.

```ruby
module Kramdown
  module Parser
    class AFM < Kramdown::Parser::GFM
      INLINE_GALLERY = /^@gallery\s+(.*?)\s*?\n/

      def initialize(source, options)
        super
        @block_parsers.insert(0, :inline_gallery)
      end

      def parse_inline_gallery
        begin
          if gallery = @src.check(self.class::INLINE_GALLERY)
            @src.pos += @src.matched_size
            start_line_number = @src.current_line_number

            file_name = @src[1]
            path = File.join(Dir.pwd, 'data', 'galleries', @src[1]) + ".yml"
            content = File.read(path)
            gallery_options = YAML.load(content)

            gallery = { path: path, name: @src[1], gallery: gallery_options}
            el = new_block_el(:gallery, gallery, nil, :category => :block, :location => @src.current_line_number)
            @tree.children << el
            true
          else
            false
          end
        rescue Exception => e
          puts "There was an error parsing gallery #{@src[1]}"
        end
      end
      define_parser(:inline_gallery, INLINE_GALLERY)
    end
  end
end
```

This looks like a lot, but the big thing is that it's creating a new `gallery` element for the renderer to translate into HTML. The `gallery` element at this point really just has the data from that YML file in it. I'll skip translating a YML file to HTML, but the basics are that whatever the contents of that YML file are they'll be set for us to convert later.

```ruby
module Middleman
  module Renderers
    class MiddlemanKramdownHTML < ::Kramdown::Converter::Html
      def convert_gallery(el, indent)
        # Convert the `el` ruby hash into all the HTML for this gallery.
        %(<section class='gallery'>#{..}</section>)
      end
    end
  end
end
```

This is similar to the `convert_p` method from before. This will be called whenever there's a gallery and should return the HTML to inject for that part of document. This menthod would create a number of `Photo` Ruby objects with each photo, then translate that photo to HTML.

## Gallery Configuration

As for the contents of the YML file, it's all defined as an array of files in the gallery. Each file has a `version`, which indicates how many columns this file should take up, or `full` if the image should take up 100% of the page.

Here's a snippet of what this YML file looks like.

```yml
---
- file: blossom_boats.jpg
  alt: Cherry Blossoms and swan boats.
  version: full
- files:
  - file: us.jpg
    alt: Us with the blossoms.
    version: col-6
  - file: lake.jpg
    alt: View of the lake.
    version: col-6
    options:
      gravity: north
- options:
    height: 434
  files:
  - file: blossoms2.jpg
    alt: Blossoms
    version: col-4
  - file: feeding_birds.mp4
    version: col-8
    alt: Some people feeding birds
    video: true
```

And here's what this would render:

@gallery japan/ueno
- file: blossom_boats.jpg
  alt: Cherry Blossoms and swan boats.
  version: full
- files:
  - file: us.jpg
    alt: Us with the blossoms.
    version: col-6
  - file: lake.jpg
    alt: View of the lake.
    version: col-6
    options:
      gravity: north
- options:
    height: 434
  files:
  - file: blossoms2.jpg
    alt: Blossoms
    version: col-4
  - file: feeding_birds.mp4
    version: col-8
    alt: Some people feeding birds
    video: true
@

When this page is loaded, the HTML is created we don't want to use the full sized versions of every image in a tiny grid -- that would be too slow. Instead, each image instantiates a new `Photo` class which knows how to create a thumbnail version of itself based on the on the settings given.

@pull right
The `picture` element and Foundation both offer methods for rendering screen size specific images.
@

For instance, for the `blossoms2.jpg` file, it'll create a thumbnail that's 434px high and 4 columns wide. This allows the initial page load to be as fast as possible. If we wanted to improve things even more, we could create multiple smaller thumbnails and show a different one based on the users screen size.

### Custom Options Per Row/Photo

The other part that makes this easily customizable is the `options` attribute which allows each row, or each image to have it's own custom settings that are passed to [Minimagick](https://github.com/minimagick/minimagick) to create the thumbnails. These are combined with some global defaults to create the end settings. This has been tremendously useful for creating rows of different height.

There's also this option with Minimagick called `gravity` that helps determine what part of a photo to use when cropping. For instance, if a thumbnail is generated but doesn't contain the face of the person in the photo, setting the gravity to `north` will change where the crop is based from. This helps get just the right thumbnail for a given size. The actual size of the thumbnail might not be in the right proportion, so when that happens, having the gravity set helps.

### Videos

There's also one video in the mix in the YML. This won't be resized, but will be in an element contained in the grid. There's a few options for videos as well -- `autoplay`, `repeat` and `controls`, which allows for some customization per-video.

## Performance

With so many images and videos on a page, page performance becomes an issue. Because of this, images aren't all loaded immediately on the page. [Unveil](http://luis-almeida.github.com/unveil) will wait for a user to scroll 200px close to the image, then start loading it -- removing the loading spinner.

The same is done for videos, which will immediately start playing after they are unveiled, then stop playing after someone scrolls them out of sight.

## Debugging Galleries

Trying to preview galleries only within a post becomes tough once a post has more than one. An easy way around this is creating another "internal use only" page for each gallery. Uploading these could be skipped during the Middleman build phase so they're not released to production if needed. I decided to upload them for the hell of it.

As an example, the gallery page for the [Japan - Ueno Park](/galleries/japan/ueno) trip shows how the gallery will render on the page. The process for creating these involves editing the yml, refreshing, seeing how it renders on the page, then repeating the process. At the bottom of the sample page is the YML that generates that gallery as well.

## Next Steps?

@pull right
Looking at photos has been great for learning, as has [Understanding Exposure](http://www.amazon.com/Understanding-Exposure-3rd-Edition-Photographs/dp/0817439390).
@

The obvious next step is to take better photos. This is a work in progress, but something I'm hoping to become better at over time.

The YML file creation of these is a major bottleneck in the gallery creation process. The photos are manipulated in Lightroom then exported before being manually processed. One of the next steps I'd like to look into is to see (if it's even possible) to export this YML file directly from Lightroom using a custom workflow. That would allow for extremely simple gallery creation.

## Inspiration

I'm very curious to see what other sites are doing similar things. [Exposure.co](https://exposure.co/) has an amazing interface to do something like this via a website, but you'll need to pay $9/month to get more than 2 posts.

[Paul Stamatiou](http://paulstamatiou.com/photos/) also has an amazing custom photo page which has inspired some parts of this iteration (namely the inline video -- which are a great addition).

Do you know of other sites -- either personal or commercial, that showcase photos in a unique or interesting way? Please let me know in the comments.
