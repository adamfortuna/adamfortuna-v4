$:.unshift File.join(File.dirname(__FILE__))

require 'pry'
require 'listen'
require 'Parallel'

require 'lib/gallery'
require 'lib/grid'


namespace :gallery do

  desc 'Watches for changes to galleries and rebuilds them if there are changes'
  task :watch do
    # Load all galleries, so we'll know if we need to do something when a file changes
    @galleries = {}
    Dir['data/galleries/**/*.yml'].each do |full_path|
      path = full_path.gsub(/(.*)(data\/galleries\/.*)/, '\2').gsub('data/galleries/', '').gsub('.yml', '')
      @galleries[path] = Gallery::Gallery.new(path)
    end

    listener = Listen.to('data/galleries') do |modified_files, added, removed|
      puts "modified absolute path: #{modified_files}"
      puts "added absolute path: #{added}"
      puts "removed absolute path: #{removed}"

      # Create any new galleries
      added.each do |file_path|
        normalized_path = file_path.gsub(/(.*)(data\/galleries\/.*)/, '\2').gsub('data/galleries/', '').gsub('.yml', '')
        @galleries[normalized_path] = Gallery::Gallery.new(normalized_path)
        @galleries[normalized_path].prepare!
      end

      modified_files.each do |file_path|
        begin
          normalized_path = file_path.gsub(/(.*)(data\/galleries\/.*)/, '\2').gsub('data/galleries/', '').gsub('.yml', '')
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
  task :yml, [:galleries] do |t, args|
    galleries = args[:galleries].split(',')
    puts "galleries: #{galleries}"

    statements = galleries.collect do |gallery_path|
      gallery = Grid::Gallery.new(gallery_path)
      if gallery.exists?
        gallery.save!
        "@gallery #{gallery_path}"
      else
        puts "Gallery #{gallery_path} does not exist"
      end
    end.compact

    puts statements.join("/n")
  end

  desc 'Creates a new post from a collection of galleries'
  task :photo, [:path] do |t, args|
    root = args[:path]
    path = File.join('source', 'images', root, '*')
    folders = Dir[path]

    # Create all YML Files
    galleries = folders.collect do |folder|
      gallery_path = folder.split('/')[-2..-1].join('/')
      gallery = Grid::Gallery.new(gallery_path)
      puts "saving gallery #{gallery_path}"
      gallery.save!
      gallery_path
    end
    gallery_root = galleries.first.split('/')[0]
    first_path = galleries.first.split('/')[1]
    gallery = Grid::Gallery.new(galleries.first)
    first_photo = gallery.items.first.filename

    sleep 1

    # Generate all thumbnalils
    total_files = 0
    results = galleries.uniq.collect do |gallery_path|
      g = Gallery::Gallery.new(gallery_path)
      total_files = total_files + g.files_count
      puts "preparing gallery #{gallery_path}"
      g.prepare!
<<-CONTENTS.strip_heredoc

## #{gallery_path.split('/').last.humanize}

@gallery #{gallery_path}

CONTENTS
    end


    # Create the post
    root = '/Users/adam/code/personal/adamfortuna.com'
    now = Time.now
    uid = "example#{(Random.rand*1000).to_i}"
    date = "#{now.year}-#{now.month}-#{now.day}"
    file_name = "#{date}-#{uid}.html.markdown"
    path = File.join(root, 'source', 'photos', 'events', file_name)
    file = File.open(path, 'w')

    content = <<-CONTENTS.strip_heredoc
---
title: #{gallery_root.humanize}
date: #{date}
collection: events
permalink: #{uid}
tags: Example
poster: /images/galleries/#{gallery_root}/#{first_path}/#{first_photo}
header: /images/galleries/#{gallery_root}/#{first_path}/#{first_photo}
description: Example, Tags
stats:
  photos: #{total_files}
---

Here's a post with some images.

#{results.join('')}
    CONTENTS

    puts "\n\nwriting file"
    puts content
    file.write(content)


    # At this point we have everything except the small versions of each
    `open http://localhost:4567/photos/events/#{uid}`
  end
end
