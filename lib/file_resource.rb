require 'open-uri'

class FileResource
  def initialize(file_object)
    @file_object = open(file_object)
  end

  def assemble_menu
    parse_total
    parse_menu_items
    [@total, @menu]
  end

  def parse_total
    @total = floatify(@file_object.lines.first)
  end

  def parse_menu_items
    @menu = {}
    ## Drop the first line because that should be the total
    @file_object.lines.drop(0).each do |line|
      split_line = line.split(',')
      ## Returns a hash with menu item as key and amout as value
      ## Also removes any unwanted charters $ , /n etc.
      ### TO-DO IF EMPTY HASH END PROGRAM RIGHT NOW ###
      @menu.merge!(clean_up(split_line))
    end
    @menu
  end

  def clean_up(split_line)
      ## should strip menu item of line breaks and give a line string
      ## for the output later on
      menu_item = split_line.first.strip
      ## takes something like "$15.05\n" and make is 15.05
      price = floatify(split_line.last)
      ## If it is an empty hash ruby will not merge not add it to hash
      ## in parse_menu_item above
      price > @total ? {} : {menu_item => price}
  end

  def floatify(string)
    ## remove anything that is not a digit "$15.05\n" should be returned as 15.05
    string.gsub(/[^\d\.]/, '').to_f
  end

end
