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
        @block_parsers.insert(0, :inline_gallery)
        @block_parsers.insert(0, :gallery)
        @block_parsers.insert(0, :pull)
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
          content = @src[1]
          gallery_options = YAML.load(content)
          add_gallery({ gallery: gallery_options})
        else
          false
        end
      end
      define_parser(:gallery, GALLERY_START)

      def parse_inline_gallery
        begin
          if gallery = @src.check(self.class::INLINE_GALLERY)
            @src.pos += @src.matched_size
            start_line_number = @src.current_line_number

            file_name = @src[1]
            path = File.join(Dir.pwd, 'data', 'galleries', @src[1]) + ".yml"
            content = File.read(path)
            gallery_options = YAML.load(content)

            # Create a new `ul` for this gallery
            add_gallery({ path: path, name: @src[1], gallery: gallery_options})
          else
            false
          end
        rescue Exception => e
          puts "There was an error parsing gallery #{@src[1]}"
        end
      end
      define_parser(:inline_gallery, INLINE_GALLERY)


      def add_gallery gallery
        el = new_block_el(:gallery, gallery, nil, :category => :block, :location => @src.current_line_number)
        @tree.children << el
        true
      end

      PULL_START = /^@pull/
      PULL_MATCH = /^@pull\s+([a-z]+)\n(.*?)^@\n/m
      def parse_pull
        if @src.check(self.class::PULL_MATCH)
          @src.pos += @src.matched_size
          start_line_number = @src.current_line_number


          content = Kramdown::Document.new(@src[2], input: 'AFM').to_html
          el = new_block_el(:pull, {direction: @src[1], content: content}, nil, :category => :block, :location => @src.current_line_number)
          @tree.children << el
          true
        else
          false
        end
      end
      define_parser(:pull, PULL_START)
    end
  end
end



module Middleman
  module Renderers
    class MiddlemanKramdownHTML < ::Kramdown::Converter::Html
      def convert_p(el, indent)
        content = inner(el, indent)
        %(<section class='wrap'><p>#{content}</p></section>)
      end

      def convert_blockquote(el, indent)
        content = format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
        %(<section class='wrap'>#{content}</section>)
      end

      def convert_header(el, indent)
        attr = el.attr.dup
        if @options[:auto_ids] && !attr['id']
          attr['id'] = generate_id(el.options[:raw_text])
        end
        @toc << [el.options[:level], attr['id'], el.children] if attr['id'] && in_toc?(el)
        level = output_header_level(el.options[:level])
        content = format_as_block_html("h#{level}", attr, inner(el, indent), indent)

        %(<section class='wrap wrap--h#{level}'>#{content}</section>)
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

        %(<section class='wrap'>#{content}</section>)
      end
      alias :convert_ol :convert_ul

      def convert_pull(el, indent)
        %(<div class='pull-#{el.value[:direction]}'>#{el.value[:content]}</div>)
      end

      def convert_gallery(el, indent)
        el.value = el.value.with_indifferent_access
        items = el.value.is_a?(Array) ? el.value : el.value[:gallery]
        name = el.value[:name]
        path = el.value[:path]

        gallery = ::Gallery::Gallery.new(path)

        content = items.collect do |gallery_item|
          gallery_item = gallery_item.with_indifferent_access
          if gallery_item['files']
            # This is a row of images
            generate_row(name, gallery_item, gallery)
          else
            ::Gallery::Photo.new(gallery_item, name, gallery_item[:options], gallery).to_html
          end
        end
        %(<section class='gallery'>#{content.join("\n")}</section>)
      end

      def generate_row name, row, gallery
        items = row[:files].collect do |image|
          ::Gallery::Photo.new(image, name, row[:options], gallery).to_html
        end

        %(<div class='row'>#{items.join("\n")}</div>)
      end

    end
  end
end
