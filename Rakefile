$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pry'
require 'yaml'
require 'gallery'
require 'gallery/gallery'
require 'gallery/item'
require 'gallery/photo'
require 'gallery/video'
require 'gallery/photo_options'

require 'grid'
require 'grid/gallery'
require 'grid/item'

require 'listen'

namespace :gallery do

  desc 'Watches for changes to galleries and rebuilds them if there are changes'
  task :watch do
    listener = Listen.to('data/galleries') do |modified_files, added, removed|
      puts "modified absolute path: #{modified_files}"
      puts "added absolute path: #{added}"
      puts "removed absolute path: #{removed}"
      [added,modified_files].flatten.each do |file_path|
        begin
          gallery = Gallery::Gallery.new(file_path)
          gallery.prepare!
        rescue Exception => e
          # noop
        end
      end
    end
    listener.start # not blocking
    puts 'Watching for changes in data/galleries...'
    sleep
  end

  task :yml_test do
    gallery = Grid::Gallery.new('panama/tour/abandon_city')
    puts gallery.to_gallery
  end

  desc 'Converts any number of folder of images into a yml file'
  task :yml do |t, args|
    galleries = args.extras

    statements = galleries.collect do |gallery_path|
      gallery = Grid::Gallery.new(gallery_path)
      if gallery.exists?
        gallery.save!
        "@gallery #{gallery_path}"
      end
    end.compact

    puts statements.join("/n")
  end
end
