$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pry'
require 'yaml'
require 'gallery'
require 'gallery/gallery'
require 'gallery/item'
require 'gallery/photo'
require 'gallery/video'
require 'gallery/photo_options'

require 'pathname'
require 'listen'

namespace :gallery do

  desc 'Watches for changes to galleries and rebuilds them if there are changes'
  task :watch do
    listener = Listen.to('data/galleries') do |modified_files, added, removed|
      puts "modified absolute path: #{modified_files}"
      puts "added absolute path: #{added}"
      puts "removed absolute path: #{removed}"
      modified_files.each do |file_path|
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

  task :yml do
    gallery = ENV['GALLERY']
    folder = File.split(gallery)[0..-2]

    # Setup the initial folder
    destination_folder = File.join('data', 'galleries', folder)
    puts "Creating folder: #{destination_folder}"
    #FileUtils.mkdir_p(destination_folder)

    # Parse out the files in the given folder
    images = File.join('source', 'images', 'galleries', gallery, "*")
    puts "Files: #{Dir[images]}"

    files = Dir[images].collect do |image|
      file = Pathname.new(image)
      {
        'file': file.basename.to_s,
        'version': 'col-4',
        'alt': file.basename.to_s.gsub(file.extname, '').capitalize
      } unless file.extname == ''
    end

    files.compact!

    groups = []
    new_group = []
    files.each_with_index do |file, index|
      if (index % 3) == 0 && !new_group.empty?
        groups << { files: new_group }
        new_group = []
      end
      new_group << file
    end
    if !new_group.empty?
      groups << { files: new_group }
    end
    puts "YML: #{groups.to_yaml}"

    # Setup the yml file
    folder  = File.join('data', 'galleries', "#{gallery.split('/').first}")
    if !Dir.exists? folder
      FileUtils.mkdir_p folder
    end

    destination_file = File.join('data', 'galleries', "#{gallery}.yml")
    puts "Creating file: #{destination_file}"
    if !File.exists?(destination_file)
      file = File.open(destination_file, 'w')
      file.write(groups.to_yaml)
    end
  end
end
