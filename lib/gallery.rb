require 'mini_magick'
require 'yaml'

class Gallery
  def initialize(config)
    @galleries = config['galleries']
    @versions = config['versions']
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
    gallery.each do |photo|
      generate_photo_versions photo_path, photo
    end
  end

  def generate_photo_versions photo_path, photo
    @dest_folder = "#{photo_path}/resized"
    file_path = File.join(photo_path, photo['file'])
    FileUtils.mkdir_p(@dest_folder)

    versions(photo).each_pair do |version, path|
      version_file_path = File.join(@dest_folder, path)

      if !File.exist?(version_file_path) || @overwrite
        image = ::MiniMagick::Image.open(file_path)

        puts "Running commands for #{version}"
        @versions[version.to_s]['commands'].each do |command|
          image.combine_options do |c|
            command.each_pair do |command, value|
              c.send command, value
            end
          end
        end

        image.write version_file_path
      end
    end
  end

  def versions v
    {
      "#{v['version']}": version_file_name(v['file'], v['version']),
      "compressed": version_file_name(v['file'], 'compressed'),
      "resized": version_file_name(v['file'], 'resized')
    }
  end

  def version_file_name src, version
    src.gsub(/\.([^\.]+)$/,  '-'+version+'.\1')
  end
end
