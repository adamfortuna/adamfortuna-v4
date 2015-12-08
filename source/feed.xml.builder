xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "Adam Fortuna"
  xml.subtitle "Blog & Portfolio"
  xml.id "http://adamfortuna.com"
  xml.link "href" => "http://adamfortuna.com"
  xml.link "href" => "http://feeds.feedburner.com/adamfortuna", "rel" => "self"
  xml.updated recent_articles.first.date.to_time.iso8601
  xml.author { xml.name "Adam Fortuna" }

  recent_articles.each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => full_url(article.url)
      xml.id full_url(article.url)
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name "Adam Fortuna" }
      xml.summary adjust_content(expand_urls(article.summary)), "type" => "html"
      xml.content adjust_content(expand_urls(article.body)), "type" => "html"
    end
  end
end
