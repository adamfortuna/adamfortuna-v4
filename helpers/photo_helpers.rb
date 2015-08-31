module PhotoHelpers

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
