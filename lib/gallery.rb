require 'active_support/all'

module Gallery
  # Load data/galleries.yml
  def self.options
    return @options if @options
    contents = File.read(File.join('/Users/adam/code/personal/adamfortuna.com', 'data', 'gallery.yml'))
    @options = YAML.load(contents)
  end
end

require 'lib/gallery/gallery'
require 'lib/gallery/item'
require 'lib/gallery/photo'
require 'lib/gallery/video'
require 'lib/gallery/photo_options'
