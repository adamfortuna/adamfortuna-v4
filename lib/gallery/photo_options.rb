module Gallery
  class PhotoOptions
    attr_accessor :options

    WHITELIST_COMMANDS = ['crop', 'gravity', 'quality', 'resize', 'gravity']
    def initialize options
      @options = options.with_indifferent_access
    end

    def identical?(other)
      (other.gravity == gravity) &&
        (other.width == width) &&
        (other.height == height) &&
        (other.crop? == crop?)
    end

    def gravity
      options[:gravity] || 'center'
    end

    def width
      options[:width] ? options[:width].to_f : 0.to_f
    end

    def height
      options[:height] ? options[:height].to_f : 0.to_f
    end

    def crop?
      [true, false].include?(options[:crop]) ? options[:crop] : options[:crop]
    end

    def commands
      return @commands if @commands
      @commands = {}

      options.each_pair do |option, value|
        if ![true, false].include?(value) && WHITELIST_COMMANDS.include?(option.to_s)
          @commands[option.to_sym] = value
        end
      end

      @commands
    end
  end
end
