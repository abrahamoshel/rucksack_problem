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

    def ordering_instructions
      @output.puts 'What is the max amount of dishes you would like to order?'
    end

    def parse_data_file(data_file)
      FileResource.new(data_file)
    end

    def suggest_items(menu, total, dish_max_ordered)
      @menu = []
      @total = total
      @max_dishes = dish_max_ordered.to_i
      menu.each {|menu_item| @menu << MyMenu::MenuItem.new(menu_item) }
      find_menu_combinations
      total_matching_combinations
      @output.print  formated_matches
    end

    def find_menu_combinations
      @combos = []
      max_dishes = @max_dishes
      while max_dishes >= 1 do
        @combos << @menu.repeated_combination(max_dishes).to_a
        max_dishes -= 1
      end
      # @menu.inject(1) do |count, item|
      #   @combos << @menu.repeated_combination(count).to_a
      #   count + 1
      # end
      @combos
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
                              : "You can order one of the follow to toal $#{total_as_dollars}"
      table = Terminal::Table.new :title => title, :rows => @message
    end

  end
end
