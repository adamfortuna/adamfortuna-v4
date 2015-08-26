module ArticleHelpers
  def article_classes article
    (article.tags || []).collect do |tag|
      "article-tag--#{tag.downcase.gsub(/\s/, '-')}"
    end.join(' ')
  end

  def tags_for_article tags=[]
    tags.collect do |tag|
      if (tag != 'Personal') && (tag != 'Technical')
        "<span>#{tag}</span>"
      end
    end.compact.join(", ")
  end
end
