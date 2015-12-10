module Gallery
  class Video < Item

    def initialize image, path, options, gallery
      super
      video_options = ::Gallery.options['video'].with_indifferent_access
      @options.options = video_options.merge(@options.options)
    end

    def prepare!
      true
    end

    def identical?(video)
      true
    end

    def different?
      false
    end

    def to_html
      html = <<-PIC
      <div class='lazy gallery--video #{column_class_for}'>
        <video #{height} data-src='#{original_url}' #{autoplay} #{controls} #{repeat} #{poster} class='gallery--video-video video-js vjs-default-skin' data-lazy-setup='#{setup}'>
          <source src='#{original_url}' type='video/mp4'>
          Your browser does not support the <code>video</code> element.
        </video>
      </div>
      PIC
      if columns_count == 12
        html = <<-PIC
          <div class='row'>
            #{html}
          </div>
        PIC
      end
      html
    end

    def setup
      {
        autoplay: options.options[:autoplay] || false,
        loop: options.options[:repeat] || false,
        controls: options.options[:controls] || false,
        poster: poster_url || '/images/placeholder.gif',
        preload: options.options[:preload] || false
      }.to_json
    end

    def autoplay
      options.options[:autoplay] ? 'data-autoplay="true"' : ''
    end

    def preload
      options.options[:preload] ? 'preload' : ''
    end

    def controls
      options.options[:controls] ? 'controls' : ''
    end

    def repeat
      options.options[:repeat] ? 'loop' : ''
    end

    def height
      options.options[:height] ? "height='#{options.options[:height]}px'" : ''
    end

    def poster_url
      @options.options['poster']
    end

    def poster
      @poster = @options.options['poster']
      if @poster
        @poster = "poster='#{gallery_path}/#{@poster}'"
      end
      @poster
    end
  end
end
