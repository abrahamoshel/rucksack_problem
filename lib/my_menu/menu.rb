require 'pry'
require 'terminal-table'

## Soluction takes about 115--125MB of memory but maxes out the CPU
## Orginally using repeated_combination to find all the permutation
## it took almost 3GB of memory before I forced the program to end

module MyMenu
  class Menu
    def initialize(output)
      @output = output
    end

    def greeting
      @output.puts 'Welcome to My Menu!'
      @output.puts 'Please Enter a File Location or URL:'
    end

    def parse_data_file(data_file)
      FileResource.new(data_file)
    end

    def suggest_items(menu, total)
      @menu = menu
      @total = total
      create_divisables_table
      make_suggestion

      # Coumment out while testing
      # @output.print  formated_matches
    end

    def create_divisables_table
      @divisables = Hash.new
      @menu.each do |menu_item|
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
      ## inserts soluctions into @combos each of the divisables
      ## plus the lowest divisable as many times as it can
      ## 8 = [4, 1, 1, 1, 1] && [3, 1, 1, 1, 1, 1]
      fill_with_lowest_divisable(match, menu)
      ## start with amount to be reached match, full menu, and how many
      ## less of the greatest divisable you want in the solution
      ## ex: 12 = [4, 4, 4] but with the 1 below you would get
      ## 12 = [4, 4, 3, 1]
      two_greatest_divisables(match, menu, 1)

      greedy_solutions(match, menu)


      @replacement_match = []
      @combos.each {|b| mutated_solutions(b) }
      solutions = @replacement_match + @combos
      solutions.sort! {|lt, gt| gt[0] <=> lt[0]}
      solutions.sort! {|a, b| a.size <=> b.size}
      solutions.uniq
    end

    def greedy_solutions(match, menu)
      menu.each do |menu_item|
        item_matches = []
        total = match
        while total % menu_item && total >= menu_item
          item_matches << menu_item
          total -= menu_item
        end

        item_matches << total if menu.include?(total)
        @combos << item_matches if item_matches.inject(:+) == @total
      end
    end

    def mutated_solutions(array)
      return [] if array.all? {|a| a == @menu.min }
      structs = []
      array.each_with_index do |arr, index|
        next if arr == @menu.min
        @divisables[arr].each do |value|
          structs << OpenStruct.new(:index =>index, :replacement => value, :array => Array.new(array))
        end
      end

      structs.each do |struct|
        replacement = struct.array.delete_at(struct.index)
        while replacement % struct.replacement && replacement >= struct.replacement
          struct.array << struct.replacement
          replacement -= struct.replacement
        end
        struct.array << replacement unless replacement == 0
        @replacement_match << struct.array.sort! {|lt, gt| gt <=> lt}
      end
      structs.collect(&:array).each {|a| mutated_solutions(a) unless a.all? {|b| b == @menu.min }}
    end

    def fill_with_lowest_divisable(match, menu)
      menu.sort! {|lt, gt| gt <=> lt}

      second_matches = []
      menu.each do |menu_item|
        total = match
        second_matches = []
        total -= menu_item
        second_matches << menu_item
        while total % menu.min && total >= menu.min
          second_matches << menu.min
          total -= menu.min
        end
        @combos << second_matches if second_matches.inject(:+) == @total
      end
    end

    def two_greatest_divisables(match, menu, count)
      menu.sort! {|lt, gt| gt <=> lt}
      menu.each_cons(2) do |menu_item, second_menu_item|
        second_matches = []
        total = match
        meh = (match / menu_item) - count
        meh.times {|i| total -= menu_item}
        meh.times {|i| second_matches << menu_item}
        while total % second_menu_item && total >= second_menu_item
            second_matches << second_menu_item
            total -= second_menu_item
        end
        @combos << second_matches if second_matches.inject(:+) == @total
      end
      two_greatest_divisables(match, menu, count +=1 ) unless count == 2
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
