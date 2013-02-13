require 'open-uri'

class MenuUtil
  # creating struct to create new menu items
  MenuItem = Struct.new(:item_name, :price)
  def initialize(file_object)
    @file_object = open(file_object)

  rescue Errno::ENOENT, OpenURI::HTTPError
    puts "You must enter a correct file path"
    exit 1
  end

  def assemble_menu
    ## takes the first line of the data file to be the total and converts to cents
    parse_total
    ## creates array of MenuItem Structs
    parse_menu_items
    [@total, @menu.compact]
  end

  def parse_total
    @total = centsify(@file_object.lines.first)
  end

  def parse_menu_items
    @menu = []
    ## Drop the first line because that should be the total
    @file_object.lines.drop(0).each do |line|
      split_line = line.split(',')
      ## Returns a array of MenuItems with the item_name and price for each item
      ## Also removes any unwanted charters $ , /n etc.
      @menu << covert_to_object(split_line)
    end
    @menu
  end

  def covert_to_object(split_line)
      ## takes something like "$15.05\n" and make is 1505
      price = centsify(split_line.last)
      ## Don't create a MenuItem if the price exceeds the total
      return if price > @total
      ## should strip menu item of line breaks
      menu_item = split_line.first.strip
      ## Using OpenStructs becuase I think it makes the code a little more
      ## readable
      MenuItem.new(menu_item, price)
  end

  ## remove anything that is not a digit and converts to cents "$15.05\n"
  ## should be returned as 1505
  def centsify(string)
    removed_charcters = string.gsub(/[^\d\.]/, '').to_f
    ## convert to cents
    (removed_charcters * 100).round.to_i
  end

end
