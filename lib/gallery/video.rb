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
      <div class='lazy gallery--video controls #{column_class_for}'>
        <video data-src='#{original_url}' #{autoplay} #{controls} #{repeat} class='gallery--video-video'>
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

    def to_gallery
      gallery = {
        file: image[:file],
        version: image[:version],
        video: true
      }

      gallery[:options] = image[:options].to_hash if image[:options]
      gallery
    end

    def autoplay
      options.options[:autoplay] ? 'data-autoplay="true"' : ''
    end

    def controls
      options.options[:controls] ? 'controls' : ''
    end

    def repeat
      options.options[:repeat] ? 'loop' : ''
    end
  end
end
