require 'pathname'


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

    def alt
      filename.gsub(@file.extname, '').capitalize
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
        alt: alt
      }

      gallery.merge!(video: true) if video?

      gallery
    end

    def video?
      ['.mp4'].include? @file.extname
    end

    def rating
      return @rating if @rating
      rating_token = @file.basename.to_s.split('.').first.split('-').last
      @rating = (rating_token =~ /r(\d)/) ? $1.to_i : nil
    rescue Exception => e
      nil
    end
  end
end
