module PhotoHelpers
  def has_tag? photo, tag
    tags = tag
    tags = [tags] unless tags.is_a?(Array)
    tags.any? do |tag|
      photo.tags.include? tag
    end
  end

  def photo_lookup collection, permalink=nil
    blog('photos').articles.find do |article|
      (article.data['collection'] == collection) &&
        (article.data['permalink'] == permalink)
    end
  end

  def photo_children parent
    parent.data['children'].collect do |child_id|
      photo_lookup(parent.data['collection'], child_id)
    end.compact
  end
end
