require 'mini_magick'
module Gallery
  class Photo
    attr_accessor :image, :path, :options

    def initialize image, path, options = {}
      @image = image.with_indifferent_access
      @path = path
      @options = PhotoOptions.new((options || {}).merge(global_options))
      write_image unless image_exists?
    end

    def to_html
      html = <<-PIC
        <picture class='#{column_class_for}'>
          <source srcset="#{src}" media="(min-width: 600px)">
          <img src="#{src}" alt="#{alt}">
        </picture>
      PIC
      if columns_count == 12
        html = <<-PIC
          <div class='row'>
            #{html}
          </div>
        PIC
      end
      html
    end

    def global_options
      @global_options ||= Gallery.options['versions'][image[:version]] || {}
    end

    def alt
      image[:alt]
    end

    def src
      @src ||= image[:src] ? image[:src] : url_for_image
    end

    def image_exists?
      File.exists?(destination_path)
    end

    def write_image
      return false unless File.exists?(source_path)
      puts "Writing new image!"
      image_file = ::MiniMagick::Image.open(source_path)

      commands = {}
      commands = crop_commands_for(image_file) if options.crop?
      commands.merge(options.commands)

      image_file.combine_options do |c|
        commands.each_pair do |command, value|
          c.send command, value
        end
      end

      puts "Writing image to #{destination_path}"
      image_file.write destination_path
    end

    # Get all minimagick options for resizing
    def crop_commands_for(image)
      gravity = options.gravity
      w_original, h_original = [image.width.to_f, image.height.to_f]
      w, h = [options.width, options.height]

      op_resize = ''

      # check proportions
      if w_original * h < h_original * w
        op_resize = "#{w.to_i}x"
        w_result = w
        h_result = (h_original * w / w_original)
      else
        op_resize = "x#{h.to_i}"
        w_result = (w_original * h / h_original)
        h_result = h
      end

      w_offset, h_offset = crop_offsets_by_gravity(gravity, [w_result, h_result], [w, h])
      crop = "#{w.to_i}x#{h.to_i}+#{w_offset}+#{h_offset}!"

      {
        resize: op_resize,
        gravity: gravity,
        crop: crop
      }
    end

    GRAVITY_TYPES = [ :north_west, :north, :north_east, :east, :south_east, :south, :south_west, :west, :center ]

    def crop_offsets_by_gravity(gravity, original_dimensions, cropped_dimensions)
      raise(ArgumentError, "Gravity must be one of #{GRAVITY_TYPES.inspect}") unless GRAVITY_TYPES.include?(gravity.to_sym)
      raise(ArgumentError, "Original dimensions must be supplied as a [ width, height ] array") unless original_dimensions.kind_of?(Enumerable) && original_dimensions.size == 2
      raise(ArgumentError, "Cropped dimensions must be supplied as a [ width, height ] array") unless cropped_dimensions.kind_of?(Enumerable) && cropped_dimensions.size == 2

      original_width, original_height = original_dimensions
      cropped_width, cropped_height = cropped_dimensions

      vertical_offset = case gravity.to_sym
        when :north_west, :north, :north_east then 0
        when :center, :east, :west then [((original_height - cropped_height) / 2.0).to_i, 0].max
        when :south_west, :south, :south_east then (original_height - cropped_height).to_i
      end

      horizontal_offset = case gravity.to_sym
        when :north_west, :west, :south_west then 0
        when :center, :north, :south then [((original_width - cropped_width) / 2.0).to_i, 0].max
        when :north_east, :east, :south_east then (original_width - cropped_width).to_i
      end

      return [horizontal_offset, vertical_offset]
    end

    def source_path
      File.join('galleries', path, image[:file])
    end

    def destination_path
      File.join('galleries', path, 'resized', version_file)
    end

    def url_for_image
      File.join('/', 'images', 'galleries', path, 'resized', version_file)
    end

    def version_file
      if image[:version] == 'full'
        image[:file].gsub(/\.([^\.]+)$/, '-full.\1')
      else
        image[:file].gsub(/\.([^\.]+)$/, '-'+image[:version]+'.\1')
      end
    end

    def columns_count
      @columns_count ||= image[:version].gsub('col-', '').to_i || 12
    end

    def column_class_for
      if image[:version] == 'full'
        'full'
      else
        "large-#{columns_count} medium-#{columns_count} columns"
      end
    end
  end
end
