---
title: "Railscast Style Syntax Highlighting for Wordpress"
permalink: railscast-style-syntax-highlighting-for-wordpress
tags: Technical, Wordpress
---

Update: This blog is no longer running WordPress. It's now running [Jekyll](https://github.com/mojombo/jekyll) but the URLs should still be valid.

Update 2: Now it's running Middleman!

[Railscasts](http://railscasts.com) has easily been the best learning tool for Ruby on Rails that I've used. When moving over into Rails, chances are your question will be answered somewhere in 173 episode show archive that grows weekly. If not you can always suggest a idea and Ryan Bates might just make a show out of it. If you've never been there then go check it out. I'll wait. All that looking at the Railscast textmate theme will make you completely fall for the colors. Just about everyone I know at [IZEA](http://izea.com) uses the [Railscast Textmate Theme](http://railscasts.com/about) because of this. It's extremely easy on the eyes, with an indescribable comfort to it. It seemed only natural to want to apply that theme here on the blog as a step towards posting more code. Luckily creating any kind of markup theme with a point of reference is a piece of cake, just need some kind of Wordpress plugin to do the heavy lifting. There's plenty of syntax highlighters out there, with one that called out as being the most feature rich and easy to implement. [SyntaxHighlighter Plus](http://wordpress.org/extend/plugins/syntaxhighlighter-plus/) is the winner for today.

### Implementation

Very simple install, as with any Wordpress plugin. Just upload and activate. After that you'll want to start changing the way you markup your code within your posts to use this new syntax. Instead of using &lt;pre&gt; tags like a number of other plugins, SyntaxHighlighter Plus uses bracket notation. For instance, this block would output some ruby code:

```
CONSTANT="first"
```

In it's finished form, here's what it looks like. Complete with Javascript hooks for showing just the code, or printing.

```ruby
# This is a comment
class Test
  @testingalongname = "Something here"
  CONSTANT = 2323
  def test
    return (1*5)
  end
end
```

### Download it

Feel free to grab my very quickly hacked up [SyntaxHighlighter Plus Railscast theme](http://adamfortuna.com/wp-content/plugins/syntaxhighlighter-plus/syntaxhighlighter/styles/railscast.css) , and use if you're using SyntaxHighlighter Plus. It's still far from complete as far as syntax highlighters go, but if anyone else out there has any improvements on it, please drop me a line. I'm also looking for some thoughts on other syntax highlighter Wordpress plugins out there. Finding the right Wordpress plugin can sometimes be a bit overwhelming when there's dozens that accomplish the same goal, so if you know of any that do it better, I'd love to look into them.

### On Github

I added a [project on github](http://github.com/adamfortuna/railscasts_wordpress/tree/master) for this. If you want to make a change to my code, or add support for another Wordpress plugin, feel free to push your changes out to me and I'll add them. Eventually maybe we'll have railscast themes for all Wordpress plugins!
