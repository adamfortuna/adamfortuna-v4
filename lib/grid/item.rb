require 'pathname'
require 'mini_exiftool'

module Grid
  class Item
    attr_accessor :path, :columns, :full

    def initialize path
      @path = path
      @file = Pathname.new(path)
    end

    def filename
      @file.basename.to_s
    end

    def version
      if full?
        'full'
      else
        "col-#{columns}"
      end
    end

    def full?
      @full
    end

    def to_gallery
      gallery = {
        file: filename,
        version: version,
      }

      gallery.merge!(title: title) if title
      gallery.merge!(alt: alt) if alt
      gallery.merge!(video: true) if video?

      gallery
    end

    def alt
      return @alt if @alt
      @alt = exif.description

      if artist
        @alt = "#{@alt} (by #{artist})"
      end

      @alt == '' ? nil : @alt
    end

    def artist
      exif.artist
    end

    def video?
      ['.mp4'].include? @file.extname
    end

    def photo?
      ['.jpg', '.png'].include? @file.extname.downcase
    end

    def rating
      return @rating if @rating
      @rating = rating_from_filename || rating_from_metadata
    end

    def title
      exif.title
    end

    private

    def rating_from_filename
      rating_token = @file.basename.to_s.split('.').first.split('-').last
      rating = (rating_token =~ /r(\d)/) ? $1.to_i : nil
      return rating if !rating

      if rating >= 1 and rating <= 5
        rating
      else
        nil
      end
    rescue Exception => e
      puts "#{e.message}"
      raise e
    end

    def rating_from_metadata
      exif.rating
    end

    def exif
      @exif ||= MiniExiftool.new @path
    end
  end
end
