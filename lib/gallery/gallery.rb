module Gallery
  class Gallery
    def initialize path
      @path = path.gsub(/(.*)(data\/galleries\/.*)/, '\2')
    end

    def files_count
      contents.inject(0) do |count, gallery_item|
        if gallery_item['files']
          count + gallery_item['files'].length
        else
          count + 1
        end
      end
    end

    # deprecated
    def photos_count
      files_count
    end

    def permalink
      name
    end

    def updated_at
      File.mtime(@path)
    end

    def name
      @path.gsub('data/galleries/', '').gsub('.yml', '')
    end

    def contents
      return @contents if @contents
      @contents = YAML.load(file_contents)
    end

    def file_contents
      @file_contents ||= File.read(@path)
    end

    def to_html
      %(<section class='gallery'>#{rows.join("\n")}</section>)
    end

    def to_yml
      file_contents
    end

    def rows
      @rows ||= contents.collect do |gallery_item|
        gallery_item = gallery_item.with_indifferent_access
        if gallery_item[:files]
          generate_row(gallery_item)
        else
          Item.create(gallery_item, name, gallery_item[:options], self).to_html
        end
      end
    end

    def generate_row row
      items = row[:files].collect do |image|
        Item.create(image, name, row[:options], self).to_html
      end

      %(<div class='row'>#{items.join("\n")}</div>)
    end
  end
end
