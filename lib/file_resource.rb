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
    @menu = []
    @file_object.lines.drop(0).each do |line|
      ## Returns a hash with menu item as key and amout as value
      ## Also removes any unwanted charters $ , /n etc.
      @menu << clean_up(line.split(','))
    end
    @menu
  end

  def clean_up(split_line)
      menu_item = keyify(split_line.first)
      price = floatify(split_line.last)
      [menu_item, price]
  end

  def keyify(string)
    string.downcase.tr(' ', '_')
  end

  def floatify(string)
    string.gsub(/[^\d\.]/, '').to_f
  end

end
