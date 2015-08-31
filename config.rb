require 'lib/gallery'
require 'lib/gallery/gallery'
require 'lib/gallery/photo'
require 'lib/gallery/photo_options'
require 'lib/kramdown'

# ====================================
#   Compass
# ====================================
compass_config do |config|
  # Require any additional compass plugins here.
  config.add_import_path 'bower_components/foundation/scss'
  config.add_import_path 'bower_components/foundation-icon-fonts'

  # Set this to the root of your project when deployed:
  config.http_path = '/'
  config.css_dir = 'stylesheets'
  config.sass_dir = 'stylesheets'
  config.fonts_dir = 'fonts'
  config.images_dir = 'images'
  config.javascripts_dir = 'javascripts'

  relative_assets = true
end

activate :automatic_image_sizes
activate :directory_indexes
# activate :livereload

activate :autoprefixer do |config|
  config.browsers = ['last 2 versions', 'Explorer >= 10']
  config.cascade = false
end

# ====================================
#   Articles
# ====================================
activate :blog do |blog|
  blog.name = 'articles'
  blog.prefix = 'articles'
  blog.permalink = '{permalink}'
  blog.sources = '{year}/{year}-{month}-{day}-{title}.html'
end
page "articles/*", :layout => :article
page "articles", :layout => :layout

# ====================================
#   Photos
# ====================================
activate :blog do |blog|
  blog.name = 'photos'
  blog.prefix = 'photos'
  blog.permalink = '{collection}/{permalink}'
  blog.sources = '{collection}/{year}-{month}-{day}-{title}.html'
end
page "photos/*", :layout => :photo
page "photos", :layout => :layout

# ====================================
#   Galleries
# ====================================
Dir[data.gallery.galleries].each do |gallery|
  path = gallery.gsub('data/galleries/', '').gsub('.yml', '')
  proxy "/galleries/#{path}", "/galleries/show.html", ignore: true, locals: { path: gallery }
end
proxy '/galleries', '/galleries/index.html'


# ====================================
#   Disqus
# ====================================
configure :development do
  activate :disqus do |d|
    d.shortname = data.config.disqus.development
    #d.shortname = nil # nill will disable disqus
  end
end
configure :build do
  activate :disqus do |d|
    d.shortname = d.shortname = data.config.disqus.production
  end
end

# ====================================
#   After Configuration
# ====================================
after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join root, @bower_config['directory']
  sprockets.append_path File.join(root, 'images', 'galleries')
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir, 'fonts'

set :haml, { ugly: true }
set :markdown_engine, :kramdown
set :markdown, :input              => 'AFM',
               :layout_engine      => :haml,
               :tables             => true,
               :autolink           => true,
               :smartypants        => true,
               :gh_blockcode       => true,
               :fenced_code_blocks => true,
               :af_gallery         => true

activate :syntax, :line_numbers => true

# ====================================
#   Build Configuration
# ====================================
configure :build do
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
  activate :relative_assets
  activate :gzip
end


configure :development do
  set :debug_assets, true
end
