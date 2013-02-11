require 'open-uri'

class MenuUtil
  MenuItem = Struct.new(:item_name, :price)
  def initialize(file_object)
    @file_object = open(file_object)
  end

  def assemble_menu
    parse_total
    parse_menu_items
    [@total, @menu]
  end

  def parse_total
    @total = centsify(@file_object.lines.first)
  end

  def parse_menu_items
    @menu = []
    ## Drop the first line because that should be the total
    @file_object.lines.drop(0).each do |line|
      split_line = line.split(',')
      ## Returns a hash with menu item as key and amout as value
      ## Also removes any unwanted charters $ , /n etc.
      ### TO-DO IF EMPTY HASH END PROGRAM RIGHT NOW ###
      @menu << covert_to_object(split_line)
    end
    @menu
  end

  def covert_to_object(split_line)
      ####
        # after find solution will be using something like
        # a.find_all {|b| [1,4].include?(b.id) }
        # a is a array of open structs
      ####


      ## takes something like "$15.05\n" and make is 1505
      price = centsify(split_line.last)
      return if price > @total
      ## should strip menu item of line breaks
      menu_item = split_line.first.strip
      ## Using OpenStructs becuase I think it makes the code a little more
      ## readable
      MenuItem.new(menu_item, price)
  end

  def centsify(string)
    ## remove anything that is not a digit and converts to cents "$15.05\n"
    ## should be returned as 15.05
    removed_charcters = string.gsub(/[^\d\.]/, '').to_f
    ## convert to cents
    (removed_charcters * 100).to_i
  end

end
