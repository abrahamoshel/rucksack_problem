## Soluction takes about 150-180MB of memory but maxes out the CPU for list of 36 items
## Orginally using repeated_combination to find all the permutation for list of 10 items
## it took almost 3GB of memory before I forced the program to end

module MyMenu
  class Menu
    ## creating struct to me used in the mutated_solutions method below
    Replacement = Struct.new(:index, :replacement, :array)
    def initialize(output)
      @output = output
      ## used for create_divisables_table method which creates a hash of hashes
      ## with possible replacements for any price in price_list
      @divisables = Hash.new
      ## set variable that will hold all working matches
      @combos = []
      ## while finding matches based on @combos use @replacement_match
      ## since we don't want to dirty @combos with non-solutions
      @replacement_match = []
      greeting
    end

    def greeting
      @output.puts 'Welcome to My Menu!'
      @output.puts 'Please Enter a File Location or URL:'
    end

    def parse_data_file(data_file)
      ## creates a MenuUtil object which is a file from a url or file system path
      @menu_util = MenuUtil.new(data_file)
      ## returns an array of MenuItem structs with item_name and the price in cents
      ## as well as the total
      @total, @orginal_menu = @menu_util.assemble_menu
    end

    def run
      ## for all the solution calculations we only need the price so we set it as @price_list
      ## also only need the unique prices because create_suggestion_list will find all items with
      ## the same pice and print out them as replacement items
      @price_list = @orginal_menu.collect(&:price).uniq
      ## starts the calculation and in the end will print out the solution in terminal
      suggest_items(@price_list, @total)
    end

    def suggest_items(price_list, total)
      price_list.reject! {|m| m > total }
      ## memoizing incase i'm testing just fixnums and not a menu_item struct
      ## refer to run method so see when menu_item stuct is created
      @price_list  ||= price_list
      @total = total
      if @price_list.empty?
        @matches =["ahhhh no items on the Menu total your desired amount"]
      else
        create_divisables_table
        ## finds solutions through serveral methods greater_divisables,
        ## greedy_solutions, and mutated_solutions
        find_menu_combinations
      end
      @output.puts "For the requested amount of $#{'%.2f' % (@total.to_i/100.0)}"
      @output.puts  formated_matches
    end

    def create_divisables_table
      ## @divisables is an empty hash created in initialize
      @price_list.each do |menu_item|
        @divisables[menu_item] = @price_list.select{|key| menu_item > key}
      end
      @divisables.reject! {| key, value | key == @price_list.min }
    end

    def find_menu_combinations
      ### first implementation
      ## changed because the overhead was too expensive up front
      # @price_list.keys.inject(1) do |count, item|
      #   @combos << @price_list.keys.repeated_combination(count).to_a
      #   count += 1
      # end

      if @total < @price_list.min || @total == 0
        return @combos
      end

      @price_list.sort! {|lt, gt| gt <=> lt}
      ## start with amount to be reached match, full menu, and how many
      ## less of the greatest divisable you want in the solution
      ## ex: 12 = [4, 4, 4] but with the 1 below you would get
      ## 12 = [4, 4, 3, 1]
      greater_divisables(@total, @price_list, 0)
      @combos += greedy_solutions(@total, @price_list)


      ## clean up all the combos because I may have duplicates the recursive method
      @combos.uniq!
      ## mutated_solutions will take all the solutions found already and find other solutions
      ## based on replacement of items in that solution menu of [3, 2, 1] with a solution
      ## of [3] can also be a solution of [2, 1]
      @combos.each {|b| mutated_solutions(b) }
      @combos += @replacement_match
      @combos.uniq!
      @matches = @combos
    end

    ## This works just like a coin machine it just returns the simplest solution
    ## if it can for total of 10 for array [8, 7, 4, 5, 2, 1] it would return [8, 2]
    ## as a solution
    def greedy_solutions(match, menu)
      matches = []
      menu.each do |menu_item|
        item_matches = []
        total = match
        while total % menu_item && total >= menu_item
          item_matches << menu_item
          total -= menu_item
        end

        item_matches << total if menu.include?(total)
        matches << item_matches if item_matches.inject(:+) == @total
      end
      matches.delete_if {|m| @combos.include?(m)}
    end

    def mutated_solutions(solution)
      return [] if solution.all? {|a| a == @price_list.min }
      structs = []
      ## Create array of structs with the divisables of a item in a solution
      ## array. ex: [3, 2, 1] would create a Replacement struct with at index
      ## of 0, 2 can replace with with a [2] and 1 can replace it with [1, 1]
      solution.each_with_index do |arr, index|
        next if arr == @price_list.min || @divisables[arr].nil?
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
        struct.array << replacement if @price_list.include?(replacement)
        @replacement_match << struct.array.sort! {|lt, gt| gt <=> lt} if struct.array.inject(:+) == @total
      end
      ## call method on itself with the new solutions to get the solutions that can be found
      ## with the lower values on the menu
      structs.each do |a|
        ## stop recursion it the sum doesn't match the target total or the last match
        ## found is the current match found
        unless @replacement_match.last == a.array || a.array.inject(:+) != @total
          mutated_solutions(a.array)
        end
      end
    end

    ## finds all solutions that might be made by the two of items next to each other in an array
    ## array = [4, 3, 2, 1], total 12 == [4, 4, 4] through greedy_solutions but this will find
    ## [4, 4, 3, 1] and [4, 3, 3, 2]
    def greater_divisables(match, menu, count)
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
        # second_matches << total if menu.any? {|item| total % item == 0 }
        @combos << second_matches if second_matches.inject(:+) == @total
      end
      greater_divisables(match, menu, count +=1) unless count == 2
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
