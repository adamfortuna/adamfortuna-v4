module Gallery
  class Video < Item

    def to_html
      html = <<-PIC
      <div class='lazy gallery--video #{column_class_for}'>
        <video data-src='#{original_url}' controls #{autoplay} class='gallery--video-video'>
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


    def autoplay
      options.options[:autoplay] ? 'data-autoplay="true"' : ''
    end

  end
end
