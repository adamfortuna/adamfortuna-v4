$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pry'
require 'yaml'
require 'Parallel'
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
    # Load all galleries, so we'll know if we need to do something when a file changes
    @galleries = {}
    Dir['data/galleries/**/*.yml'].each do |path|
      @galleries[path] = Gallery::Gallery.new(path)
    end

    listener = Listen.to('data/galleries') do |modified_files, added, removed|
      puts "modified absolute path: #{modified_files}"
      puts "added absolute path: #{added}"
      puts "removed absolute path: #{removed}"

      # Create any new galleries
      added.each do |file_path|
        normalized_path = file_path.gsub("#{Dir.pwd}/", '')
        @galleries[normalized_path] = Gallery::Gallery.new(normalized_path)
        @galleries[normalized_path].prepare!
      end

      modified_files.each do |file_path|
        begin
          normalized_path = file_path.gsub("#{Dir.pwd}/", '')
          @galleries[normalized_path].refresh!
        rescue Exception => e
          puts "Exception: #{e.message}"
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
