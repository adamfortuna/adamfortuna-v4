require 'kramdown'
require 'yaml'

module Kramdown
  module Parser
    class AFM < Kramdown::Parser::GFM
      GALLERY_START = /^@gallery\n/
      GALLERY_MATCH = /^@gallery\s+(.*?)\s*?\n(.*?)^@\n/m
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
          content = @src[2]
          gallery_options = YAML.load(content)
          add_gallery({ name: @src[1],  gallery: gallery_options})
        else
          false
        end
      end
      define_parser(:gallery, INLINE_GALLERY)

      def parse_inline_gallery
        begin
          if gallery = @src.check(self.class::INLINE_GALLERY)
            @src.pos += @src.matched_size
            start_line_number = @src.current_line_number

            file_name = @src[1]
            path = File.join(Dir.pwd, 'data', 'galleries', @src[1]) + ".yml"
            content = File.read(path)
            gallery_options = YAML.load(content)

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
        if indent == 0
          %(<section class='wrap'><p class='wrap--inner'>#{content}</p></section>)
        else
          %(<p>#{content}</p>)
        end
      end

      def convert_table(el, indent)
        if indent == 0
          el.attr['class'] ||= ''
          el.attr['class'] = "#{el.attr['class']} wrap--inner".strip
        end
        content = format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)

        if indent == 0
          %(<section class='wrap'>#{content}</section>)
        else
          content
        end
      end

      def convert_blockquote(el, indent)
        if indent == 0
          el.attr['class'] ||= ''
          el.attr['class'] = "#{el.attr['class']} wrap--inner".strip
        end
        content = format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)

        if indent == 0
          %(<section class='wrap'>#{content}</section>)
        else
          content
        end
      end

      def convert_header(el, indent)
        attr = el.attr.dup
        if @options[:auto_ids] && !attr['id']
          attr['id'] = generate_id(el.options[:raw_text])
        end
        @toc << [el.options[:level], attr['id'], el.children] if attr['id'] && in_toc?(el)
        level = output_header_level(el.options[:level])
        if indent == 0
          attr['class'] ||= ''
          attr['class'] = "#{attr['class']} wrap--inner".strip
        end
        content = format_as_block_html("h#{level}", attr, inner(el, indent), indent)

        if indent == 0
          %(<section class='wrap wrap--h#{level}'>#{content}</section>)
        else
          content
        end
      end

      def convert_ul(el, indent)
        content = if !@toc_code && (el.options[:ial][:refs].include?('toc') rescue nil)
          @toc_code = [el.type, el.attr, (0..128).to_a.map{|a| rand(36).to_s(36)}.join]
          @toc_code.last
        elsif !@footnote_location && el.options[:ial] && (el.options[:ial][:refs] || []).include?('footnotes')
          @footnote_location = (0..128).to_a.map{|a| rand(36).to_s(36)}.join
        else
          if indent == 0
            el.attr['class'] ||= ''
            el.attr['class'] = "#{el.attr['class']} wrap--inner".strip
          end
          format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
        end

        if indent == 0
          %(<section class='wrap'>#{content}</section>)
        else
          content
        end
      end
      alias :convert_ol :convert_ul

      def convert_pull(el, indent)
        %(<div class='pull-#{el.value[:direction]}'>#{el.value[:content]}</div>)
      end

      def convert_gallery(el, indent)
        el.value = el.value.with_indifferent_access
        contents = el.value.is_a?(Array) ? el.value : el.value[:gallery]
        path = el.value[:path]

        gallery = ::Gallery::Gallery.new(contents)
        gallery.name = el.value[:name] if el.value[:name]

        # Generate the HTML for this gallery
        gallery.to_html
      rescue Exception => e
        binding.pry
        %(<section class='gallery row'><p>GALLERY IN PROCESS</p><p>#{e.message}</p><p>#{e.backtrace}</p></section>)
      end
    end
  end
end
