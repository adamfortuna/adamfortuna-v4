module Gallery
  # Load data/galleries.yml
  def self.options
    return @options if @options
    contents = File.read(File.join('data', 'gallery.yml'))
    @options = YAML.load(contents)
  end
end
