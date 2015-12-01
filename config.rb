require 'lib/middleman_overrides'
require 'lib/gallery'
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

  relative_assets = false
end

activate :automatic_image_sizes
activate :directory_indexes
#activate :livereload

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
  blog.tag_template = 'articles/tag.html'
  blog.taglink = 'tags/{tag}'
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
  end
end
configure :build do
  activate :disqus do |d|
    d.shortname = data.config.disqus.production
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

# Enable Asset Hosts
activate :asset_host
set :asset_host do |asset|
  '/'
end

configure :build do
  ignore '/bower_components/*'
  ignore '/galleries/*'
  ignore '/upublished/*'
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
  activate :relative_assets
  activate :gzip

  set :file_watcher_ignore, [
    /^bin(\/|$)/,
    /^\.bundle(\/|$)/,
    /^vendor(\/|$)/,
    /^node_modules(\/|$)/,
    /^\.sass-cache(\/|$)/,
    /^\.cache(\/|$)/,
    /^\.git(\/|$)/,
    /^\.gitignore$/,
    /\.DS_Store/,
    /^\.rbenv-.*$/,
    /^Gemfile$/,
    /^Gemfile\.lock$/,
    /~$/,
    /(^|\/)\.?#/,
    /^tmp\//,
    /^source\/bower_components(\/|$)/,
    /^unpublished\//
  ]
end

configure :development do
  set :debug_assets, true

  # Don't watch bower or gallery images
  set :file_watcher_ignore, [
    /^bin(\/|$)/,
    /^\.bundle(\/|$)/,
    /^vendor(\/|$)/,
    /^node_modules(\/|$)/,
    /^\.sass-cache(\/|$)/,
    /^\.cache(\/|$)/,
    /^\.git(\/|$)/,
    /^\.gitignore$/,
    /\.DS_Store/,
    /^\.rbenv-.*$/,
    /^Gemfile$/,
    /^Gemfile\.lock$/,
    /~$/,
    /(^|\/)\.?#/,
    /^tmp\//,
    /^source\/bower_components(\/|$)/,
    /^source\/images\/galleries(\/|$)/,
    /^unpublished\//
  ]
end

# ====================================
#   Deployment
# ====================================
activate :s3_sync do |s3_sync|
  # The name of the S3 bucket you are targetting. This is globally unique.
  s3_sync.bucket                     = data.aws.bucket
  s3_sync.region                     = 'us-east-1' # The AWS region for your bucket.
  s3_sync.aws_access_key_id          = data.aws.access_key
  s3_sync.aws_secret_access_key      = data.aws.secret
  # We delete stray files by default.
  s3_sync.delete                     = true
  # We do not chain after the build step by default.
  s3_sync.after_build                = false
  s3_sync.prefer_gzip                = true
  s3_sync.path_style                 = true
  s3_sync.reduced_redundancy_storage = false
  s3_sync.acl                        = 'public-read'
  s3_sync.encryption                 = false
  s3_sync.prefix                     = ''
  s3_sync.version_bucket             = false
end
