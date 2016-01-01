require 'dimensions'
require 'mini_magick'

MiniMagick.configure do |config|
  config.cli = :imagemagick
end

module Gallery
  class Photo < Item
    def prepare!
      if !files_exists? || out_of_date? || force_reload?
        write_images
      end
    end

    def files_exists?
      thumbnail_exists? && resized_exists?
    end

    def thumbnail_dimensions
      @file_dimensions ||= thumbnail_exists? ? Dimensions.dimensions(destination_path) : []
    end

    def full_dimensions
      @resized_dimensions ||= resized_exists? ? Dimensions.dimensions(full_destination_path) : []
    end

    def width
      @options.width
    end

    def height
      @options.height
    end

    def color
      image[:color] || find_color
    end

    def has_color?
      image[:color]
    end

    def title
      image[:title] || alt
    end

    def to_gallery
      gallery = {
        file: image[:file],
        version: version,
        color: color
      }

      gallery.merge!(title: image[:title]) if image[:title]
      gallery.merge!(alt: alt) if alt

      gallery
    end

    def to_html
      return @to_html if @to_html
      styles = []

      if image[:version] == 'full'
        styles << "height:auto"
        styles << "width:auto"
        styles << "min-height:600px"
        styles << "min-width:100%"
      elsif image[:version] == 'col-12'
        styles << "width:1170px"
        calculated_height = (1170.0/width)*height
        styles << "max-height:#{calculated_height}px"
      else
        styles << "width:#{width}px"
        styles << "height:#{height}px"
      end

      if has_color?
        styles << "background-color:#{color}"
      end

      @to_html = <<-PIC
        <a href='#{full_src}' class='lazy gallery--photo #{column_class_for}'>
          <span class='gallery-photo--placeholder' style="#{styles.join(';')};"></span>
          <span class='gallery-photo-about'>#{title}</span>
          <img class='gallery--photo-image' data-src="#{src}" alt="#{alt}" style="#{styles.join(';')};" data-size="#{full_dimensions[0]}x#{full_dimensions[1]}"/>
        </a>
      PIC
      # data-size="#{resized_dimensions[0]}x#{resized_dimensions[1]}"
      if columns_count == 12
        @to_html = <<-PIC
          <div class='row'>
            #{@to_html}
          </div>
        PIC
      end

      @to_html
    rescue Exception => e
      puts "to_html error: #{e.message}"
      raise e
    end

    def identical?(photo)
      (columns_count == photo.columns_count) &&
        (version == photo.version) &&
        (options.identical?(photo.options))
    end

    def delete!
      FileUtils.rm_f(destination_path) rescue nil
      FileUtils.rm_f(full_destination_path) rescue nil
    end

    private

    def write_images
      return false unless File.exists?(source_path)

      if force_reload? || !thumbnail_exists? || !same_dimensions?
        write_processed_image
      end

      if force_reload? || !resized_exists?
        write_resized_image
      end
    end

    def thumbnail_exists?
      File.exists?(destination_path)
    end

    def resized_exists?
      File.exists?(full_destination_path)
    end

    def same_dimensions?
      return false unless thumbnail_exists?
      if image[:version] || image[:version] == 'col-12'
        return thumbnail_exists?
      end
      (thumbnail_dimensions[0].to_i == width.to_i) && (thumbnail_dimensions[1].to_i == height.to_i)
    end

    def write_resized_image
      image_file = ::MiniMagick::Image.open(source_path)
      image_file.combine_options do |i|
        i.resize "2500>x2500>"
        i.quality "90"
      end
      FileUtils.mkdir_p(full_destination_folder)
      image_file.write full_destination_path
      image_file.destroy!
    rescue Exception => e
      puts "ENV['PATHEXT']: #{ENV['PATHEXT']}"
      puts "PATH: #{ENV['PATH']}"
      puts "Mogrify: #{MiniMagick::Utilities.which('mogrify')}"
      puts "Opening file: #{source_path}"
      puts "Error writing resized image to #{full_destination_path}"
      puts "File.exists?: #{File.exists?(source_path)}"
      raise e
    end

    def write_processed_image
      image_file = ::MiniMagick::Image.open(source_path)

      commands = {}
      commands = crop_commands_for(image_file) if options.crop?
      commands.merge!(options.commands)

      image_file.combine_options do |c|
        commands.each_pair do |command, value|
          c.send command, value
        end
      end

      FileUtils.mkdir_p(destination_folder)
      image_file.write destination_path
      image_file.destroy!
    rescue Exception => e
      puts "ENV['PATHEXT']: #{ENV['PATHEXT']}"
      puts "PATH: #{ENV['PATH']}"
      puts "Mogrify: #{MiniMagick::Utilities.which('mogrify')}"
      puts "Opening file: #{source_path}"
      puts "Error Writing processed image to #{destination_path} with commands #{commands}"
      puts "File.exists?: #{File.exists?(source_path)}"
      raise e
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
      # crop = "#{w.to_i}x#{h.to_i}+#{w_offset}+#{h_offset}!"
      crop = "#{w.to_i}x#{h.to_i}+0+0!"

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

    def find_color
      return @color if @color

      convert = MiniMagick::Tool::Convert.new
      convert << destination_path
      convert.colors(1)
      convert.unique_colors('txt:-')
      result = convert.call

      @color = result.match(/#[0-9A-F]{6}/).to_s
    end
  end
end
