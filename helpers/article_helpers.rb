module ArticleHelpers

  def disqus_shortname
    data.config.disqus[environment]
  end

  def disqus_permalink commentable
    "#{data.config.url}#{commentable.url}"
  end
  # "#{data.config.url}/articles/#{commentable.data.permalink}"

  def disqus_identifier commentable
    return commentable.data['disqus_identifier'] if commentable.data['disqus_identifier']

    "#{data.config.disqus.identifier}-/#{commentable.data['permalink']}"
  end

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
    blog_name ||= 'articles'
    tags.collect do |tag|
      "<span>#{tag}</span>"
    end.join(", ")
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

  def tag_links tags, blog_name
    tags.collect do |tag|
      link_to tag, tag_path(tag, blog_name), { class: 'tag--link' }
    end.join(', ')
  end
end
