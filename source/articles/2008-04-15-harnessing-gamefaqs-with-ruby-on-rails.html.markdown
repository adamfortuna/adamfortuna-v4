---
title: "Harnessing GameFaqs with Ruby on Rails and Hpricot"
permalink: harnessing-gamefaqs-with-ruby-on-rails-and-hpricot
tags: Technical, Ruby
---

One of the things that's most annoying when making sites that rely on external data is keeping them in sync. Although this usually means importing some sample data during development, eventually you'll have to do it *the right way* . This evening I hit that point on a project where I needed to get a list of all arcade games from [GameFAQs](http://www.gamefaqs.com) . Keeping these updated manually is completely out of the question, especially considering there's over 3500 of them. I decided to turn to [Hpricot](http://code.whytheluckystiff.net/hpricot/) , which I'd heard about on [Peepcode](http://www.peepcode.com) as well a number of other blogs. Hpricot is a very simple HTML parser for ruby. To get started, just install the hpricot gem…

```bash
$ gem install hpricot
```

After that you can require it in your controller and go wild. I needed to get a list of all arcade games available on GameFaqs for this, so that means hitting 27 different pages and parsing the results (26 letters + all numbers). My Games table is extremely simple at this point with just an ID, name and gamefaqs\_id. Since all I really need is to update my local games table with the data from GameFaqs, I also want to make sure I don't insert duplicate records. One thing to note though: GameFaqs has multiple names for the same game. You might pull back 3 different games with a specific id. In my case I'm just using the first one I find, but you could switch this up easily enough. So where's the code?

```ruby
task :gamefaqs_id => :environment do
 letters = ('a'..'z').to_a << '0'

  @gamefaq_ids = Game.find(:all).collect(&:gamefaqs_id)

  letters.each do |letter|
    html = open('http://www.gamefaqs.com/coinop/arcade/list_'+letter+'.html')
    page = Hpricot(html)

    page.search( "//div#container/div#content/div#sky_col_wrap/div#main_col_wrap/div#main_col/div[@class='pod']/div[@class='body']/table/tr" ).each do |g|
      a = g.search( "//td:first/a").first
      name = a.inner_html
      link = a['href']
      gamefaqs_id = link.match(/[0-9]+/)[0]

      # Add this games data if it doesn't exist
      if !@gamefaq_ids.include?(gamefaqs_id)
        if game = Game.find_by_name(name)
          game.update_attribute(:gamefaqs_id, gamefaqs_id)
        else
          Game.create({:name => name, :gamefaqs_id => gamefaqs_id})
        end
        @gamefaq_ids << gamefaqs_id
      end
    end
 end
 puts "Updated games.gamefaqs_id"
end
```

Not too bad for 29 lines in Rails. The letters variable contains all possible endings for the URL, with a pair of loops to do the work. The main work goes on in the `page.search()` part, which generates an array of td elements containing the information we need. From this you can grab the a element and then the `gamefas_id` and game name.
