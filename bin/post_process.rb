$:.unshift File.join(File.dirname(__FILE__), '../')
require 'pry'
require 'active_support/all'
require 'Parallel'
require 'lib/gallery'
require 'lib/grid'

def folder_for_image image
  if image =~ /--(\w*)-/
    $1
  else
    nil
  end
end

if ENV['FILE']
  file = File.open(ENV['FILE'])
  contents = file.read
  all_photos = contents.split("\n").join(' ')

  f = File.open('/Users/adam/code/personal/adamfortuna.com/bin/contents.txt', 'w')
  f.write(contents)
  f.close
end

galleries = []
photos = ENV['PHOTOS'] || all_photos
photos = photos.split(' ')
example = photos[0].split('/')
root = '/Users/adam/code/personal/adamfortuna.com'

# ['Users', 'adam', 'code', ...]
shared_tokens = example[0..(example.length-2)]

# montreal
gallery_root = shared_tokens.last

# /Users/adam/code/personal/adamfortuna.com/source/images/galleries/montreal
shared_path = shared_tokens.join('/')

# Move all photos into subdirectories based on their folder
first_photo = nil
first_path = nil
photos.each do |photo|
  folder = folder_for_image(photo)
  path = Pathname.new(photo)
  folder_path = File.join(shared_path, folder)
  FileUtils.mkdir_p folder_path if !Dir.exists?(folder_path)
  first_photo ||= path.basename.to_s
  first_path ||= folder

  FileUtils.mv photo, File.join(shared_path, folder, path.basename.to_s), force: true
  galleries << "#{gallery_root}/#{folder}"
end



# Create all gallery files for these
galleries.uniq.each do |gallery_path|
  gallery = Grid::Gallery.new(gallery_path)
  gallery.save!
end

sleep 1

# Generate all thumbnalils
results = galleries.uniq.collect do |gallery_path|
  g = Gallery::Gallery.new(gallery_path)
  g.prepare!
<<-CONTENTS.strip_heredoc

## #{gallery_path.split('/').last.humanize}

@gallery #{gallery_path}

CONTENTS
end


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
  photos: #{photos.length}
---

Here's a post with some images.

#{results.join('')}
CONTENTS

file.write(content)


# At this point we have everything except the small versions of each

`open http://localhost:4567/photos/events/#{uid}`
