require 'mini_magick'
require 'yaml'

class Gallery
  def initialize(config)
    @galleries = config['galleries']
    @versions = config['versions']
  end

  # Load data/galleries.yml
  def self.options
    return @options if @options
    contents = File.read(File.join('/', 'data', 'gallery.yml'))
    @options = YAML.load(contents)
  end

  def generate!(overwrite=false)
    @overwrite = overwrite
    Dir[@galleries].each do |gallery_path|
      contents = File.read(gallery_path)
      gallery = YAML.load(contents)
      gallery_image_path = gallery_path.gsub('data/', '').gsub('.yml', '')

      generate_gallery gallery_image_path, gallery
    end
  end

  def generate_gallery photo_path, gallery
    gallery.each do |gallery_item|
      if gallery_item['files']
        gallery_item['files'].each do |photo|
          generate_photo_versions photo_path, photo, gallery_item['height']
        end
      else
        generate_photo_versions photo_path, gallery_item
      end
    end
  end

  def generate_photo_versions photo_path, photo, height=nil
    @dest_folder = "#{photo_path}/resized"
    file_path = File.join(photo_path, photo['file'])
    FileUtils.mkdir_p(@dest_folder)

    versions(photo).each_pair do |version, path|
      version_file_path = File.join(@dest_folder, path)

      if !File.exist?(version_file_path) || @overwrite
        image = ::MiniMagick::Image.open(file_path)
        puts "Running commands for #{photo_path} #{photo['file']} on #{version} at path #{file_path}"

        options = @versions[version.to_s].clone
        options['default'] ||= {}
        options['default']['height'] = height if height
        if photo['defaults']
          options['default']['height'] = photo['defaults']['height'] if photo['defaults']['height']
          options['default']['crop'] = photo['defaults']['crop'] if photo['defaults']['crop']
        end
        write_image(image, version_file_path, options)
      end
    end
  end

  # image.combine_options do |c|
  #   command.each_pair do |command, value|
  #     if command == 'crop'
  #       value = value.gsub(/x\d+-/, "x#{height}-")
  #     end
  #     c.send command, value
  #   end
  # end

  def write_image(image, destination_path, options = {})
    if options['default'] && options['default']['crop']
      resize_with_crop(image, destination_path, options)
    else
      image.combine_options do |c|
        options['commands'].each_pair do |command, value|
          c.send command, value
        end
      end
      image.write destination_path
    end
  end

  def resize_with_crop(image, destination_path, options = {})
    gravity = options['commands']['gravity'] || :center
    w_original, h_original = [image.width.to_f, image.height.to_f]
    w, h = [options['default']['width'].to_f, options['default']['height'].to_f]

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
    puts "Cropping to #{crop}"
    image.combine_options do |i|
      i.resize(op_resize)
      i.gravity(gravity)
      i.crop(crop)
    end

    puts "writing to #{destination_path}"
    image.write destination_path
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
      when :center, :east, :west then [ ((original_height - cropped_height) / 2.0).to_i, 0 ].max
      when :south_west, :south, :south_east then (original_height - cropped_height).to_i
    end

    horizontal_offset = case gravity.to_sym
      when :north_west, :west, :south_west then 0
      when :center, :north, :south then [ ((original_width - cropped_width) / 2.0).to_i, 0 ].max
      when :north_east, :east, :south_east then (original_width - cropped_width).to_i
    end

    return [ horizontal_offset, vertical_offset ]
  end

  def versions v
    {
      "#{v['version']}": version_file_name(v['file'], v['version']),
      "full": version_file_name(v['file'], 'full')
    }
  end

  def version_file_name src, version
    src.gsub(/\.([^\.]+)$/,  '-'+version+'.\1')
  end
end
