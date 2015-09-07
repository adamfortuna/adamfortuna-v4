require 'mini_magick'

module Gallery
  class Photo < Item
    def initialize image, path, options, gallery
      super
      write_images if !files_exists? || out_of_date? || force_reload?
    end

    def files_exists?
      File.exists?(destination_path) && File.exists?(full_destination_path)
    end

    def to_html
      file = MiniMagick::Image.open(destination_path)
      height = file.height
      if image[:version] == 'full'
        height = "height:auto"
        width = "width:auto"
      elsif file.width > 1170
        width = "width:1170px"
        height = (1170.0/file.width)*file.height
        height = "max-height:#{height}px"
      else
        width = "width:#{file.width}px"
        height = "height:#{file.height}px"
      end

      resized_file = MiniMagick::Image.open(full_destination_path)

      html = <<-PIC
        <a href='#{full_src}' class='lazy gallery--photo #{column_class_for}'>
          <img class='gallery--photo-image' data-src="#{src}" alt="#{alt}" style="#{height};#{width};" data-size="#{resized_file.width}x#{resized_file.height}" />
        </a>
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

    private

    def write_images
      return false unless File.exists?(source_path)
      write_resized_image
      write_processed_image
    end

    def write_resized_image
      FileUtils.mkdir_p(full_destination_folder)
      image_file = ::MiniMagick::Image.open(source_path)
      image_file.combine_options do |i|
        i.resize "2500>x2500>"
        i.quality "90"
      end
      puts "Writing resized image to #{full_destination_path}"
      image_file.write full_destination_path
    end

    def write_processed_image
      FileUtils.mkdir_p(destination_folder)

      image_file = ::MiniMagick::Image.open(source_path)

      commands = {}
      commands = crop_commands_for(image_file) if options.crop?
      commands.merge!(options.commands)

      image_file.combine_options do |c|
        commands.each_pair do |command, value|
          c.send command, value
        end
      end

      puts "Writing processed image to #{destination_path} with commands #{commands}"
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
  end
end
