module PhotoHelpers
  def has_tag? photo, tag
    tags = tag
    tags = [tags] unless tags.is_a?(Array)
    tags.any? do |tag|
      photo.tags.include? tag
    end
  end

  def photo_url article
    "/photos/#{article.collection}/#{article.permalink}"
  end

  def photo_lookup collection, permalink=nil
    blog('photos').articles.find do |article|
      (article.data['collection'] == collection) &&
        (article.data['permalink'] == permalink)
    end
  end

  def photo_children parent
    (parent.data['children'] || []).collect do |child_id|
      photo_lookup(parent.data['collection'], child_id)
    end.compact
  end

  def event_photos
    blog('photos').articles.reject do |article|
      travel = article.tags.include?('Travel')
      series = article.data['series']
      travel || series
    end
  end

  def travel_photos
    blog('photos').articles.collect do |article|
      article if article.tags.include?('Travel') && !article.data['parent']
    end.compact
  end

  def next_photo article, parent
    # First article will be the first child
    if article.data['children']
      photo_lookup(article.data['collection'], article.data['children'].first)
    else
      index = parent.data['children'].index(article.data['permalink'])
      next_permalink = parent.data['children'][index+1]
      photo_lookup(article.data['collection'], next_permalink) if next_permalink
    end
  end

  def previous_photo article, parent
    if article.data['children']
      nil
    else
      index = parent.data['children'].index(article.data['permalink'])
      if index == 0
        parent
      else
        next_permalink = parent.data['children'][index-1]
        photo_lookup(article.data['collection'], next_permalink) if next_permalink
      end
    end
  end
end
