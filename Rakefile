$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pry'
require 'yaml'
require 'gallery'

namespace :gallery do
  desc 'Parse through all galleries and create thumbnails and mini versions for each.'
  task :generate do
    overwrite = ENV['OVERWRITE'] || false
    options = YAML.load(File.read('data/gallery.yml'))
    gallery = Gallery.new(options)

    gallery.generate!(overwrite)
  end
end
