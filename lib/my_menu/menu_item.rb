module MyMenu
  class MenuItem
    attr_accessor :menu_item, :price

    def initialize(args)
      @menu_item, @price = args
    end

  end
end
