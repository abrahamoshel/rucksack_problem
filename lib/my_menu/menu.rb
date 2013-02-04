require 'pry'
require 'terminal-table'

module MyMenu
  class Menu
    def initialize(output)
      @output = output
    end

    def greeting
      @output.puts 'Welcome to My Menu!'
      @output.puts 'Please Enter a File Location or URL:'
    end

    # def ordering_instructions
    #   @output.puts 'What is the max amount of dishes you would like to order?'
    # end

    def parse_data_file(data_file)
      FileResource.new(data_file)
    end

    def suggest_items(menu, total)
      @menu = menu
      @total = total
      create_divisables_table
      make_suggestion
      # menu.each {|menu_item| @menu << MyMenu::MenuItem.new(menu_item) }
      # find_menu_combinations
      # total_matching_combinations

      # Coumment out while testing
      # @output.print  formated_matches
    end

    def create_divisables_table
      @divisables = Hash.new
      @menu.each do |menu_item|
        ## orginally select {|key| menu_item % key == 0 } but I need all the
        ## numbers lower than it not just the factors
        @divisables[menu_item] = @menu.select{|key| menu_item > key}
      end
      @divisables.reject! {| key, value | key == @menu.min }
    end

    def make_suggestion
      if @menu.empty?
      else
        @combos = []
        find_menu_combinations(@total, @menu)
        # find all the combinations of the keys (menu items)
        # sum the values of those keys if they don't equal the total reject them
        # return the matches
      end
    end

    def find_menu_combinations(match, menu)
      ### first implementation
      ## last try before TDD
      # @menu.keys.inject(1) do |count, item|
      #   @combos << @menu.keys.repeated_combination(count).to_a
      #   count += 1
      # end

      if match < menu.min || match == 0
        return @combos
      end

      menu.sort! {|lt, gt| gt <=> lt}

      menu.each do |menu_item|
        item_matches = []
        total = match
        while total % menu_item && total >= menu_item
          item_matches << menu_item
          total -= menu_item
        end

        # duplicate_items = Hash.new(0)
        # item_matches.each do |count|
        #   duplicate_items[count] += 1
        # end

        item_matches << total if menu.include?(total)
        @combos << item_matches if item_matches.inject(:+) == @total


        if item_matches.inject(:+) == @total
          [@divisables.keys,  item_matches].reduce(:&).each do |key|
            find_every_replacement(item_matches, key)
          end
        end

        # if duplicate_items.values.any? {|v| v > 1} && menu_item != menu.min
        #   selected_menu = menu.select {|m| menu_item % m == 0}
        #   iterator(menu_item, selected_menu) unless selected_menu.size <= 1
        # end
      end
      @combos.sort! {|lt, gt| gt[0] <=> lt[0]}
      @combos.sort! {|a, b| a.size <=> b.size}
      @combos.uniq
    end
    def find_every_replacement(item_matches, key)
      replacement_match = []
      stuff = @divisables[key]

      item_matches.map do |s|
        if s == key
          @divisables[key].each do |divisable|
            while key %  divisable && key >= divisable
              replacement_match << divisable
              key -= divisable
            end
          end
        else
          replacement_match << s
        end
      end
      replacement_match.sort! {|lt, gt| gt <=> lt}
      @combos << replacement_match if replacement_match.inject(:+) == @total
      # item_matches.each_with_index |match, index|

      #   @divisables[key].each |replacement|
      #     while match % menu_item && total >= menu_item
      #       second_matches << menu_item
      #       total -= menu_item
      #     end
      # end
      # binding.pry
    end

    def iterator(match, menu)
      menu.sort! {|lt, gt| gt <=> lt}

      second_matches = []
      menu.each do |menu_item|
        total = match
        while total % menu_item && total >= menu_item
          second_matches << menu_item
          total -= menu_item
        end

        @combos << second_matches if second_matches.inject(:+) == @total
      end

    end

    def add_items_equal_to_total
      ## returns all other hashes that don't equal total
      binding.pry
    end

    def total_matching_combinations
      @matches = []
      @combos.each do |combo_array|
        combo_array.each do |array|
          array_total = array.map(&:price).inject(&:+)
          @matches << array if sprintf('%.2f', array_total).to_f == @total
        end
      end
    end

    def formated_matches
      @message = []
      @matches.each {|match| @message << match.collect(&:menu_item)}
      tablize
    end

    def tablize
      total_as_dollars = '%.2f' % @total
      title = @message.empty? ? "Sorry no combination of the items can equal $#{total_as_dollars}" \
                              : "You can order one of the follow to total $#{total_as_dollars}"
      table = Terminal::Table.new :title => title, :rows => @message
    end

  end
end
