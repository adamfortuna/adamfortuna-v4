module Gallery
  class Item
    attr_accessor :image, :path, :options, :gallery

    def initialize image, path, options, gallery
      @image = image.with_indifferent_access
      @path = path
      @gallery = gallery
      gallery_options = options || {}
      image_options = image[:options] || {}
      combined_options = global_options.merge(gallery_options).merge(image_options)
      @options = PhotoOptions.new(combined_options)
    end

    def self.create item, path, options, gallery
      klass = item[:video] ? Video : Photo
      klass.new(item, path, options, gallery)
    end

    def force_reload?
      ENV['FORCE_RELOAD'] || false
    end

    def out_of_date?
      return false if !gallery
      gallery.updated_at > File.mtime(destination_path)
    end

    def global_options
      @global_options ||= ::Gallery.options['versions'][image[:version]] || {}
    end

    def alt
      image[:alt]
    end

    def src
      @src ||= image[:src] ? image[:src] : url
    end

    def full_src
      @full_src ||= image[:src] ? image[:src] : full_url
    end

    def files_exists?
      File.exists?(destination_path) && File.exists?(full_destination_path)
    end

    def version_file
      if image[:version] == 'full'
        image[:file].gsub(/\.([^\.]+)$/, '-full.\1')
      else
        image[:file].gsub(/\.([^\.]+)$/, '-'+image[:version]+'.\1')
      end
    rescue Exception => e
      puts "Could not determine a version for image #{image}"
    end

    def columns_count
      @columns_count ||= image[:version].gsub('col-', '').to_i || 12
    end

    def column_class_for
      if (image[:version] == 'full')
        image[:version]
      else
        "medium-#{columns_count} small-12 columns left"
      end
    end

    def source_path
      File.join('source', 'images', 'galleries', path, image[:file])
    end

    def destination_path
      File.join('source', 'images', 'galleries', path, 'processed', version_file)
    end

    def destination_folder
      File.join('source', 'images', 'galleries', path, 'processed')
    end

    def full_destination_path
      File.join('source', 'images', 'galleries', path, 'resized', image[:file])
    end

    def full_destination_folder
      File.join('source', 'images', 'galleries', path, 'resized')
    end

    def url
      File.join('/', 'images', 'galleries', path, 'processed', version_file)
    end

    def full_url
      File.join('/', 'images', 'galleries', path, 'resized', image[:file])
    end

    def original_url
      File.join('/', 'images', 'galleries', path, image[:file])
    end
  end
end
