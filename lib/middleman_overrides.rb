require "middleman-sprockets/extension"

# Sprockets extension
module Middleman
  class SprocketsExtension < Extension


    # Add sitemap resource for every image in the sprockets load path
    def manipulate_resource_list(resources)
      resources_list = []

      environment.imported_assets.each do |imported_asset|
        if imported_asset.logical_path.to_s =~ /^\/galleries/
          next
        end

        asset = Middleman::Sprockets::Asset.new @app, imported_asset.logical_path, environment
        if imported_asset.output_path
          destination = imported_asset.output_path
        else
          destination = @app.sitemap.extensionless_path( asset.destination_path.to_s )
        end

        next if @app.sitemap.find_resource_by_destination_path destination.to_s

        resource = ::Middleman::Sitemap::Resource.new( @app.sitemap, destination.to_s, asset.source_path.to_s )
        resource.add_metadata options: { sprockets: { logical_path: imported_asset.logical_path }}

        resources_list << resource
      end

      resources + resources_list
    end
  end
end
