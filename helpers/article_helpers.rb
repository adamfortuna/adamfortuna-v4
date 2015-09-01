module ArticleHelpers

  def classes_from_offset large_offset, medium_offset=nil, small_offset=nil
    large_offset ||= 2
    large_columns = 12 - large_offset

    medium_offset ||= large_offset - 1
    medium_offset = 0 if medium_offset < 0
    medium_columns = 12 - medium_offset

    "large-#{large_columns} large-offset-#{large_offset} medium-offset-#{medium_offset} medium-#{medium_columns}"
  end

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

  def full_date date
    date.strftime('%B %e, %Y')
  end

  def short_date date
    date.strftime('%B %e, %Y')
  end

  # Todo: Turn these into links
  def tags tags
    tags.join(', ')
  end
end
