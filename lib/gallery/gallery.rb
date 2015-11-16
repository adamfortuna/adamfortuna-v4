require 'Parallel'
require 'benchmark'
require 'active_support/all'

module Gallery
  class Gallery
    attr_accessor :contents, :name

    def initialize starter
      if starter.is_a? String
        @path = path.gsub(/(.*)(data\/galleries\/.*)/, '\2')
        @contents = YAML.load(file_contents)
      else
        @contents = starter
      end
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
      @name ||= @path.gsub('data/galleries/', '').gsub('.yml', '')
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
      @rows ||= items.collect do |row|
        row.is_a?(Array) ? generate_row(row) : row.to_html
      end
    end

    def generate_row items
      %(<div class='row'>#{items.collect(&:to_html).join("\n")}</div>)
    end

    # Prepares all images for view by resizing them
    def prepare!
      prepare_in_parallel!
    end

    def prepare_in_parallel!
      @prepared ||= Parallel.each(items.flatten, progress: "Preparing Gallery #{name}") do |item|
        item.prepare!
      end
      puts "Finished preparing #{@prepared.length} item(s)."
    end

    def prepare_in_serial!
      items.flatten.each do |item|
        item.prepare!
      end
    end

    # Returns a nested array of all items in this gallery
    # Each item in the top level array is a row in the gallery
    def items
      @items ||= contents.collect do |gallery_item|
        gallery_item = gallery_item.with_indifferent_access

        # This is a row with multiple item
        if gallery_item[:files]
          to_return = gallery_item[:files].collect do |item|
            Item.create(item, name, gallery_item[:options], self)
          end
        # This a row with a full width item
        else
          to_return = Item.create(gallery_item, name, gallery_item[:options], self)
        end

        to_return
      end
    end
  end
end
