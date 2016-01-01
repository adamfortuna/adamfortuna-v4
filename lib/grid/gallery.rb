# TODO: Generate all videos
# TODO: Split up 12 column items throughout each gallery
# TODO: Figure out how to not have as many corner intersections

require 'yaml'

module Grid
  class Gallery
    attr_accessor :items

    def initialize path
      @path = path
      images = File.join(root, 'source', 'images', 'galleries', path, '*')
      @items = Dir[images].collect do |item|
        ::Grid::Item.new(item) unless Dir.exists?(item)
      end.compact
    end

    def exists?
      rows.length > 0
    end

    def rows
      return @rows if @rows
      @rows = []

      @remaining_items = @items
      while !@remaining_items.empty?
        @rows << generate_row
      end

      @rows
    end

    def to_gallery
      rows.collect do |row|
        group_from_row(row)
      end
    end

    # in both
    def save!
      begin
        # Setup the yml file
        folder_path = @path.split('/')
        folder_path.pop()

        folder  = File.join(root, 'data', 'galleries', folder_path)
        if !Dir.exists? folder
          puts "Creating #{folder}"
          FileUtils.mkdir_p folder
        end

        destination_file = File.join(root, 'data', 'galleries', "#{@path}.yml")
        puts "Creating file: #{destination_file}"
        if !File.exists?(destination_file)
          puts "Writing file to #{destination_file}"
          file = File.open(destination_file, 'w')
          file.write(to_gallery.to_yaml)
          file.close
        end
      rescue Exception => e
        raise StandardError.new "Error for folder #{folder} - #{e.message}"
      end
    end

    private

    def group_from_row(row)
      if row.length == 1
        item = row.first
        if row.first.full?
          return item.to_gallery
        else
          return { files: [item.to_gallery] }
        end
      else
        return {
          files: row.collect { |item| item.to_gallery }
        }
      end
    end

    def generate_row
      # If only 1 items, show it either as full screen or 12 columns
      if @remaining_items.length == 1 && item = @remaining_items.pop()
        puts "generate_row: 1 item left"
        item.columns = 12
        item.full = (item.rating == 5)

        @last_full_width = item.columns
        row = [item]

      # If only 2 items, show them on the same row
      elsif @remaining_items.length == 2
        puts "generate_row: 2 items left"
        row = generate_pair_row

      # If any remaining rows have a rank of 5, give them their own row
      elsif @remaining_items.length > 2 && rank_remaining?(5)
        puts "generate_row: high ranking 5 item"
        # Find the item and make it big

        high_rank_index = @remaining_items.collect(&:rating).index(5)
        item = @remaining_items.slice!(high_rank_index)
        item.columns = 12
        item.full = true
        row = [item]

      elsif @remaining_items.length > 2 && rank_remaining?(4)
        puts "generate_row: high ranking 4 item"
        # Find the item and make it big

        high_rank_index = @remaining_items.collect(&:rating).index(4)
        item = @remaining_items.slice!(high_rank_index)

        item.columns = 12
        item.full = false

        row = [item]

      # Otherwise there's more than 3 items, but none are high ranked
      # Try to create a row with 4 elements in it if there's an item
      # with a 1 rating
      else
        if @remaining_items.length > 4
          if [1,1,2].shuffle.first == 1
            row = multiple_row
          else
            row = generate_pair_row
          end
        elsif [1,2].shuffle.first == 1 # Flip a coin
          row = multiple_row
        else
          row = generate_pair_row
        end
      end

      row.shuffle
    end

    def multiple_row
      item = find_next_random_item
      item.columns = [3,3,4].shuffle.first

      # How many items should this row be? Either 3 or 4.
      # We'll need 2 or 3 more images for this row
      if @remaining_items.length <= 3
        desired_items = 3
      elsif @remaining_items.length <= 4
        desired_items = 2
      else
        desired_items = [2,2,3].shuffle.first
      end

      generate_multi_row(item, 3, desired_items)
    end

    def rating_difference(item1, item2)
      (item1.rating - item2.rating).abs
    end

    def generate_pair_row
      # If these two are similar in rating, show them both as col-6
      item1, item2 = @remaining_items.shift(), @remaining_items.shift()

      # If these images were more than 2 ratings different
      #   ex: 5,3 or 4,2
      if rating_difference(item1, item2) > 1
        # Figure out how many columns each should take up
        total_rating = item1.rating + item2.rating

        if item1.rating > item2.rating
          item1.columns =  (12*(item1.rating.to_f/total_rating.to_f)).ceil
          item2.columns =  (12*(item2.rating.to_f/total_rating.to_f)).floor
        else
          item2.columns =  (12*(item2.rating.to_f/total_rating.to_f)).ceil
          item1.columns =  (12*(item1.rating.to_f/total_rating.to_f)).floor
        end

      # If these two were 5,4 or 3,4, etc
      else
        item1.columns = 6
        item2.columns = 6
      end

      [item1, item2]
    end

    def rank_remaining?(rank)
      @remaining_items.any? { |i| i.rating == rank }
    end

    def generate_multi_row(item, used_columns, desired_items_count)
      remaining_columns = 12.0-used_columns
      items = []
      desired_items_count.times do |row|
        items << find_next_random_item
      end
      items.compact!

      total_rating = items.collect(&:rating).sum
      items.shuffle!
      items.each_with_index do |item, index|
        columns = (remaining_columns.to_f * (item.rating.to_f/total_rating.to_f))
        item.columns = (index % 2 == 0) ? columns.ceil : columns.floor
      end

      items = [item, items].flatten

      if items.collect(&:columns).sum > 12
        items.last.columns = items.last.columns - 1
      end

      items.shuffle
    end

    def find_next_random_item
      (@remaining_items.length % 2 == 0) ? find_low_item : find_high_item
    end

    def find_low_item
      begin
        return nil if @remaining_items.length == 0

        ratings = @remaining_items.collect(&:rating)
        min_index = ratings.rindex(ratings.min)
        @remaining_items.slice!(min_index)
      rescue Exception => e
        binding.pry
      end
    end

    def find_high_item
      begin
        return nil if @remaining_items.length == 0

        ratings = @remaining_items.collect(&:rating)
        max_index = ratings.rindex(ratings.max)
        @remaining_items.slice!(max_index)
      rescue Exception => e
        binding.pry
      end
    end

    def root
      '/Users/adam/code/personal/adamfortuna.com'
    end
  end
end
