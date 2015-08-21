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
activate :livereload

activate :autoprefixer do |config|
  config.browsers = ['last 2 versions', 'Explorer >= 10']
  config.cascade = false
end

# ====================================
#   Articles
# ====================================
activate :blog do |blog|
  blog.name = 'articles'
  blog.layout = 'article_layout'
  blog.prefix = 'articles'
  blog.permalink = '{title}'
end

# ====================================
#   Photos
# ====================================
activate :blog do |blog|
  blog.name = 'photos'
  blog.layout = 'photo_layout'
  blog.prefix = 'photos'
  blog.permalink = '{title}'
end

# ====================================
#   Helpers
# ====================================
helpers do
  # If you need helpers for use in this file, then you
  # can define them here. Otherwise, they should be defined
  # in `helpers/custom_helpers.rb`.
end


# ====================================
#   After Configuration
# ====================================
after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join root, @bower_config['directory']
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir, 'fonts'

# ====================================
#   Build Configuration
# ====================================
configure :build do
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
  activate :relative_assets
end
