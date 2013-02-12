require 'pry'
require 'terminal-table'

## Soluction takes about 115--125MB of memory but maxes out the CPU
## Orginally using repeated_combination to find all the permutation
## it took almost 3GB of memory before I forced the program to end

module MyMenu
  class Menu
    ## creating struct to me used in the mutated_solutions method below
    Replacement = Struct.new(:index, :replacement, :array)
    def initialize(output)
      @output = output
      greeting
    end

    def greeting
      @output.puts 'Welcome to My Menu!'
      @output.puts 'Please Enter a File Location or URL:'
    end

    def parse_data_file(data_file)
      ## creates a MenuUtil object which is a file from a url or file system path
      @menu_util = MenuUtil.new(data_file)
    end

    def run
      ## returns an array of MenuItem structs with item_name and the price in cents
      ## as well as the total
      total, menu = @menu_util.assemble_menu
      ## keep orginal_menu so that we can collect the output as menu_item names
      ## in the menu_item_name method
      @orginal_menu = menu
      ## for all the solution calculations we only need the price so we set it as @menu
      @menu = menu.collect(&:price)
      ## starts the calculation and in the end will print out the solution in terminal
      suggest_items(@menu, total)
    end

    def suggest_items(menu, total)
      menu.reject! {|m| m > total }
      ## memoizing incase i'm testing just fixnums and not a menu_item struct
      ## refer to run method so see when menu_item stuct is created
      @menu  ||= menu
      @total = total
      create_divisables_table
      if @menu.empty?
        @matches =["ahhhh no items on the Menu total your desired amount"]
      else
        ## set varoable that will hold all the matches
        @combos = []
        ## finds solutions through serveral methods two_greatest_divisables,
        ## greedy_solutions, and mutated_solutions
        find_menu_combinations(@total, @menu)
      end
      @output.puts "For the request amount of $#{'%.2f' % (@total.to_i/100.0)}"
      @output.puts  formated_matches
    end

    def create_divisables_table
      @divisables = Hash.new
      @menu.each do |menu_item|
        @divisables[menu_item] = @menu.select{|key| menu_item > key}
      end
      @divisables.reject! {| key, value | key == @menu.min }
    end

    def find_menu_combinations(match, menu)
      ### first implementation
      ## changed because the overhead was too expensive up front
      # @menu.keys.inject(1) do |count, item|
      #   @combos << @menu.keys.repeated_combination(count).to_a
      #   count += 1
      # end

      if match < menu.min || match == 0
        return @combos
      end

      menu.sort! {|lt, gt| gt <=> lt}
      ## start with amount to be reached match, full menu, and how many
      ## less of the greatest divisable you want in the solution
      ## ex: 12 = [4, 4, 4] but with the 1 below you would get
      ## 12 = [4, 4, 3, 1]
      two_greatest_divisables(match, menu, 1)
      greedy_solutions(match, menu)

      @replacement_match = []
      ## clean up all the combos because I may have duplicates the recursive method
      @combos.uniq!
      ## mutated_solutions will take all the solutions found already and find other solutions
      ## based on replacement of items in that solution menu of [3, 2, 1] with a solution
      ## of [3] can also be a solution of [2, 1]
      @combos.each {|b| mutated_solutions(b) }

      solutions = @replacement_match + @combos
      solutions.uniq!
      @matches = solutions
    end

    ## This works just like a coin machine it just returns the simplest solution
    ## if it can for total of 10 for array [8, 7, 4, 5, 2, 1] it would return [8, 2]
    ## as a solution
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

    def mutated_solutions(solution, count=0)
      return [] if solution.all? {|a| a == @menu.min }
      structs = []
      ## Create array of structs with the divisables of a item in a solution
      ## array. ex: [3, 2, 1] would create a Replacement struct with at index
      ## of 0, 2 can replace with with a [2] and 1 can replace it with [1, 1]
      solution.each_with_index do |arr, index|
        next if arr == @menu.min || @divisables[arr].nil?
        @divisables[arr].each do |replaceable|
          structs << Replacement.new(index, replaceable, Array.new(solution))
        end
      end

      structs.each do |struct|
        replacement = struct.array.delete_at(struct.index)
        while replacement % struct.replacement && replacement >= struct.replacement
          struct.array << struct.replacement
          replacement -= struct.replacement
        end
        struct.array << replacement if @menu.include?(replacement)
        @replacement_match << struct.array.sort! {|lt, gt| gt <=> lt} if struct.array.inject(:+) == @total
      end
      ## call method on itself with the new solutions to get the solutions that can be found
      ## with the lower values on the menu
      structs.collect(&:array).each {|a| mutated_solutions(a, count += 1) unless
        ## stop recursion it the sum doesn't match the target total or the last match
        ## found is the current match found
        @replacement_match.last == a || a.inject(:+) != @total}
    end

    ## finds all solutions that might be made by the two of items next to each other in an array
    ## array = [4, 3, 2, 1], total 12 == [4, 4, 4] through greedy_solutions but this will find
    ## [4, 4, 3, 1] and [4, 3, 3, 2]
    def two_greatest_divisables(match, menu, count)
      menu.sort! {|lt, gt| gt <=> lt}
      menu.each_cons(2) do |menu_item, second_menu_item|
        second_matches = []
        total = match
        quotient = (match / menu_item) - count
        quotient.times {|i| total -= menu_item}
        quotient.times {|i| second_matches << menu_item}
        while total % second_menu_item && total >= second_menu_item
            second_matches << second_menu_item
            total -= second_menu_item
        end
        @combos << second_matches if second_matches.inject(:+) == @total
      end
      two_greatest_divisables(match, menu, count +=1 ) unless count == 2
    end

    ## formats the solutions for the ouput in terminal
    def formated_matches
      @message = []
      @matches.each {|match| @message << menu_item_name(match) }
      ## Another check to see if matches came from rspec just using Fixnums or if it is a real menu
      if @message[0][0].is_a?(Fixnum)
        @message
      else
        @message.join("\n\n -----------------NEW SUGGESTION----------------------- \n\n")
      end
    end

    ## called from above
    ## it returns the menu_item name unless the message for no items found
    ## or if @orginal_menu is nil it means that it was from the rspec test so
    ## don't format anything
    def menu_item_name(match)
      return match if match.is_a?(String) || @orginal_menu.nil?
      item_by_name = []
      match.each do |mat|
        item = @orginal_menu.select {|m| mat == m.price}.collect(&:item_name)
        item_by_name <<
          if item.size > 1
            ## If there are multipule items in item than that means that there
            ## are replacement items -- aka menu_items with the same value so we
            ## should suggest those as 1 to 1 replacements in the solutions
            create_suggestion_list(item)
          else
           item
          end
      end
      item_by_name.join(", ")
    end

    def create_suggestion_list(item)
      first_suggestion = item.delete_at(0)
      string_output =<<-EOS

#{first_suggestion}
you can also replace it with one of these items:
#{item}

EOS
    end
  end
end
