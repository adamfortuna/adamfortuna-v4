# A sample Guardfile
# More info at https://github.com/guard/guard#readme

directories %w(data/galleries).select{ |d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

notification :gntp

group 'galleries' do
  guard :shell do
    watch /.*/ do |m|
      m[0] + " has changed."
    end
  end
end
