module Gallery
  class Gallery
    attr_accessor :contents, :name

    def initialize starter
      if starter.is_a? String
        # starter = montreal/travel
        starter = starter.gsub(/(.*)(data\/galleries\/.*)/, '\2').gsub('data/galleries/', '').gsub('.yml', '')
        @path = File.join(root, 'data', 'galleries', starter) + '.yml'
        @contents = YAML.load(file_contents)
      else
        @contents = starter
      end
    rescue Exception => e
      puts "Error parsing #{starter}"
      raise e
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
      @name ||= @path.gsub(/(.*)(data\/galleries\/.*)/, '\2').gsub('data/galleries/', '').gsub('.yml', '')
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

    def folder_path
      return @folder_path if @folder_path
      @folder_path = @path.split('/')
      @folder_path.pop()
      @folder_path = @folder_path.join('/')
      @folder_path
    end

    def save!
      begin
        # Create the folder
        if !Dir.exists? folder_path
          puts "Creating #{folder_path}"
          #FileUtils.mkdir_p folder_path
        end

        puts "Writing file to #{@path}"
        puts "With:"
        puts to_gallery.to_yaml
        file = File.open(@path, 'w')
        file.write(to_gallery.to_yaml)
        file.close
      rescue Exception => e
        raise StandardError.new "Error: #{e.message}"
      end
    end

    def to_gallery
      items.collect do |row|
        group_from_row(row)
      end
    end

    def colorize!

    end

    # Used to update in the event of file changes
    def refresh!
      updated_contents = File.read(@path)
      updated_yml = YAML.load(updated_contents)

      updated_items = fetch_items(updated_yml)
      original_items = items.flatten

      updated_items.flatten.each do |updated_item|
        original_item = original_items.find do |oi|
          oi.full_src == updated_item.full_src
        end

        # If this is a new item, we're good
        next if !original_item

        # Otherwise, we'll need to see if this file changed
        if !original_item.identical?(updated_item)
          original_item.delete!
        end
      end

      @items = updated_items

      prepare!
    end

    # Prepares all images for view by resizing them
    def prepare!
      prepare_in_parallel!
    end

    def prepare_in_parallel!
      @prepared = Parallel.each(items.flatten, progress: "Preparing Gallery #{name}") do |item|
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
      @items ||= fetch_items(contents)
    end

    def fetch_items(files)
      files.collect do |gallery_item|
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

    def root
      '/Users/adam/code/personal/adamfortuna.com'
    end

    def group_from_row(row)
      if row.is_a? Array
        return {
          files: row.collect { |item| item.to_gallery }
        }
      else
        if row.full?
          return row.to_gallery # version = full
        else
          return { files: row.to_gallery } # version = col-12
        end
      end
    end
  end
end
