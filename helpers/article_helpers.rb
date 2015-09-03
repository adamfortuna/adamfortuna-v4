module ArticleHelpers

  def disqus_shortname
    if environment == :development
      data.config.disqus[environment]
    else
      data.config.disqus.production
    end
  end

  def disqus_permalink commentable
    "#{site_url}#{commentable.url}"
  end

  def site_url
    if environment == :development
      data.config.development.url
    else
      data.config.production.url
    end
  end

  def disqus_identifier commentable
    "#{data.config.disqus.identifier}-/#{commentable.data['disqus_identifier'] || commentable.data['permalink']}"
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
