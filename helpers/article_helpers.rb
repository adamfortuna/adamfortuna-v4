module ArticleHelpers
  def article_classes article
    (article.tags || []).collect do |tag|
      "article-tag--#{tag.downcase.gsub(/\s/, '-')}"
    end.join(' ')
  end

  def custom_page_classes
    (page_classes || '') + " " + (yield_content(:pageClasses) || '') + ' ' + (yield_content(:postClasses) || '')
  end

  def tags_for_article tags=[]
    tags.collect do |tag|
      if (tag != 'Personal') && (tag != 'Technical')
        "<span>#{tag}</span>"
      end
    end.compact.join(", ")
  end

  def article_body_classes article
    (article.tags || []).collect do |tag|
      "article--#{tag.downcase.gsub(/\s/, '-')}"
    end.join(' ')
  end

end
