require 'kramdown'
require 'yaml'

module Kramdown
  module Parser
    class AFM < Kramdown::Parser::GFM
      GALLERY_START = /^@gallery\n/
      GALLERY_MATCH = /^@gallery\n(.*?)^@\n/m

      INLINE_GALLERY = /^@gallery\s+(.*?)\s*?\n/

      def initialize(source, options)
        super
        @block_parsers.insert(0, :gallery)
        @block_parsers.insert(0, :inline_gallery)
      end

      # A Gallery object
      # ex:
      #
      # @gallery
      # - alt: My Laptop
      #  src: http://parisvega.com/wp-content/uploads/2010/04/apple-mbp2011-15-frontface_osx-lg.jpg
      # @
      def parse_gallery
        if gallery = @src.check(self.class::GALLERY_MATCH)
          @src.pos += @src.matched_size
          start_line_number = @src.current_line_number
          content = gallery.match(self.class::GALLERY_MATCH)[1]
          gallery_options = YAML.load(content)
          add_gallery(gallery_options)
        else
          false
        end
      end
      define_parser(:gallery, GALLERY_START)

      def parse_inline_gallery
        if gallery = @src.check(self.class::INLINE_GALLERY)
          @src.pos += @src.matched_size
          start_line_number = @src.current_line_number

          file_name = @src[1]
          path = File.join(Dir.pwd, 'data', 'galleries', @src[1]) + ".yml"
          content = File.read(path)
          gallery_options = YAML.load(content)

          # Create a new `ul` for this gallery
          add_gallery({ path: @src[1], gallery: gallery_options})
        else
          false
        end
      end
      define_parser(:inline_gallery, INLINE_GALLERY)


      def add_gallery gallery
        el = new_block_el(:gallery, gallery, nil, :category => :block, :location => @src.current_line_number)
        @tree.children << el
        true
      end
    end
  end
end



module Middleman
  module Renderers
    class MiddlemanKramdownHTML < ::Kramdown::Converter::Html
      def convert_p(el, indent)
        content = inner(el, indent)
        %(<div class='wrap--p'><p>#{content}</p></div>)
      end

      def convert_header(el, indent)
        attr = el.attr.dup
        if @options[:auto_ids] && !attr['id']
          attr['id'] = generate_id(el.options[:raw_text])
        end
        @toc << [el.options[:level], attr['id'], el.children] if attr['id'] && in_toc?(el)
        level = output_header_level(el.options[:level])
        content = format_as_block_html("h#{level}", attr, inner(el, indent), indent)

        %(<div class='wrap--h#{level}'>#{content}</div>)
      end

      def convert_ul(el, indent)
        content = if !@toc_code && (el.options[:ial][:refs].include?('toc') rescue nil)
          @toc_code = [el.type, el.attr, (0..128).to_a.map{|a| rand(36).to_s(36)}.join]
          @toc_code.last
        elsif !@footnote_location && el.options[:ial] && (el.options[:ial][:refs] || []).include?('footnotes')
          @footnote_location = (0..128).to_a.map{|a| rand(36).to_s(36)}.join
        else
          format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
        end

        %(<div class='wrap--#{el.type}'>#{content}</div>)
      end

      def convert_gallery(el, indent)
        el.value = el.value.with_indifferent_access
        files = el.value.is_a?(Array) ? el.value : el.value[:gallery]

        content = files.collect do |image|
          image = image.with_indifferent_access
          column_class = image[:version] ? "large-#{columns_for_version(image[:version])} medium-#{columns_for_version(image[:version])} columns" : ''
          src = image[:src] ? image[:src] : url_for_image(el.value[:path], image)

          "<li class='#{column_class}'><img src='#{src}' alt='#{image[:alt]}' /></li>"
        end.join("\n")

        %(<div class='wrap--gallery'><ul class='gallery no-bullet large-12'>#{content}</ul></div>)
      end

      def columns_for_version(version)
        version.gsub('col-', '').gsub('-tall', '')
      end

      def version_file image
        image[:file].gsub(/\.([^\.]+)$/, '-'+image[:version]+'.\1')
      end

      def url_for_image path, image
        path = File.join('galleries', path, 'resized', version_file(image))
        "http://localhost:4000/#{path}"
      end
    end
  end
end
