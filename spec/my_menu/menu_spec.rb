require 'spec_helper'

module MyMenu
  describe Menu do
    let(:output) { double('output').as_null_object }
    let(:menu) { Menu.new(output) }

    describe "start" do
      it "sends a welcome message" do
        output.should_receive(:puts).with('Welcome to My Menu!')
        menu.greeting
      end
      it "prompts for file or url" do
        output.should_receive(:puts).with('Please Enter a File Location or URL:')
        menu.greeting
      end
    end

    describe "data file entry" do
      it "sends data file results to output" do
        file_resource = menu.parse_data_file("http://www.tablexi.com/menu.txt")
        file_resource.should be_a_kind_of(FileResource)
      end
    end

    describe "suggesting items" do
      let(:my_menu) { [1, 2, 3, 4] }

      context 'total is either 0 or less than the smallest menu item' do
        total = -1
        it "should suggest [] as item menu for negative amount" do
          menu.suggest_items(my_menu, total).should == []
        end

        it "should suggest [] as item menu for amount of 0" do
          total = 0
          menu.suggest_items(my_menu, total).should == []
        end

        it "should suggest [] as item menu for amount less than smallest item menu" do
          total = 1
          my_menu.replace([2, 3, 4])
          menu.suggest_items(my_menu, total).should == []
        end
      end

      context 'total is not 0 and larger than the smallest menu item' do
        total = 1
        it "should suggest 1 as item menu for amount of 1" do
          menu.suggest_items(my_menu, total).should =~ [[1]]
        end

        it "should have 2 suggestions amount of 2" do
          total = 2
          menu.suggest_items(my_menu, total).should =~
            [ [2],
              [1, 1]
            ]
        end

        it "should have 3 suggestions amount of 3" do
          total = 3
          menu.suggest_items(my_menu, total).should =~
            [ [3],
              [2, 1],
              [1, 1, 1]
            ]
        end
        it "should have 5 suggestions amount of 4" do
          total = 4
          menu.suggest_items(my_menu, total).should =~
            [ [4],
              [3, 1],
              [2, 2], [2, 1, 1],
              [1, 1, 1, 1]
            ]
        end
        it "should have 6 suggestions amount of 5" do
          total = 5
          ## later change == to =~
          menu.suggest_items(my_menu, total).should =~
            [ [4, 1],
              [3, 2], [3, 1, 1],
              [2, 2, 1], [2, 1, 1, 1],
              [1, 1, 1, 1, 1]
            ]
        end
        it "should have 9 suggestions amount of 6 with [1, 2, 3, 4] as options" do
          total = 6
          ## later change == to =~
          menu.suggest_items(my_menu, total).should =~
            [ [4, 2], [4, 1, 1],
              [3, 3], [3, 2, 1], [3, 1, 1, 1],
              [2, 2, 2], [2, 2, 1, 1], [2, 1, 1, 1, 1],
              [1, 1, 1, 1, 1, 1]
            ]
        end
        it "should have 11 suggestions amount of 7 with [1, 2, 3, 4] as options" do
          total = 7
          ## later change == to =~
          menu.suggest_items(my_menu, total).should =~
            [ [4, 3], [4, 2, 1], [4, 1, 1, 1],
              [3, 3, 1], [3, 2, 2], [3, 2, 1, 1], [3, 1, 1, 1, 1],
              [2, 2, 2, 1], [2, 2, 1, 1, 1], [2, 1, 1, 1, 1, 1],
              [1, 1, 1, 1, 1, 1, 1]
            ]
        end
        it "should have 15 suggestions amount of 8 with [1, 2, 3, 4] as options" do
          total = 8
          ## later change == to =~
          menu.suggest_items(my_menu, total).should =~
            [ [4, 4], [4, 3, 1], [4, 2, 2], [4, 2, 1, 1], [4, 1, 1, 1, 1],
              [3, 3, 2], [3, 3, 1, 1], [3, 2, 2, 1], [3, 2, 1, 1, 1], [3, 1, 1, 1, 1, 1],
              [2, 2, 2, 2], [2, 2, 2, 1, 1], [2, 2, 1, 1, 1, 1], [2, 1, 1, 1, 1, 1, 1],
              [1, 1, 1, 1, 1, 1, 1, 1]
            ]
        end
        it "should have 17 suggestions amount of 9 with [1, 2, 3, 4] as options" do
          total = 9
          ## later change == to =~
          menu.suggest_items(my_menu, total).should =~
            [ [4, 4, 1], [4, 3, 1, 1], [4, 2, 2, 1], [4, 2, 1, 1, 1], [4, 1, 1, 1, 1, 1],
              [3, 3, 3], [3, 2, 2, 2], [3, 3, 2, 1], [3, 3, 1, 1, 1], [3, 2, 2, 1, 1],
                        [3, 2, 1, 1, 1, 1], [3, 1, 1, 1, 1, 1, 1],

              [2, 2, 2, 2, 1], [2, 2, 2, 1, 1, 1], [2, 2, 1, 1, 1, 1, 1],
                        [2, 1, 1, 1, 1, 1, 1, 1],

              [1, 1, 1, 1, 1, 1, 1, 1, 1]
            ]
        end
        it "should have 23 suggestions amount of 10 with [1, 2, 3, 4] as options" do
          total = 10
          ## later change == to =~
          menu.suggest_items(my_menu, total).should =~
            [ [4, 4, 2], [4, 3, 3], [4, 3, 2, 1], [4, 3, 1, 1, 1], [4, 4, 1, 1], [4, 2, 2, 2],
                        [4, 2, 2, 1, 1], [4, 2, 1, 1, 1, 1], [4, 1, 1, 1, 1, 1, 1],

              [3, 3, 3, 1], [3, 3, 2, 2], [3, 3, 2, 1, 1], [3, 2, 2, 2, 1],
                        [3, 2, 2, 1, 1, 1], [3, 3, 1, 1, 1, 1], [3, 2, 1, 1, 1, 1, 1], [3, 1, 1, 1, 1, 1, 1, 1],

              [2, 2, 2, 2, 2], [2, 2, 2, 2, 1, 1], [2, 2, 2, 1, 1, 1, 1],
                        [2, 2, 1, 1, 1, 1, 1, 1], [2, 1, 1, 1, 1, 1, 1, 1, 1],

              [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            ]
        end
        it "should have 42 suggestions amount of 10 with [1, 2, 3, 4, 5, 6, 7, 8, 9 , 10] as options" do
          total = 10
          my_menu.replace([1, 2, 3, 4, 5, 6, 7, 8, 9 , 10])
          ## later change == to =~
          menu.suggest_items(my_menu, total).should =~
            [
              [10],
              [9, 1],
              [8, 2], [8, 1, 1],
              [7, 3], [7, 2, 1], [7, 1, 1, 1],
              [6, 4], [6, 3, 1], [6, 2, 2], [6, 2, 1, 1], [6, 1, 1, 1, 1],

              [5, 5], [5, 4, 1], [5, 3, 2], [5, 3, 1, 1], [5, 2, 2, 1],
                      [5, 2, 1, 1, 1], [5, 1, 1, 1, 1, 1],

              [4, 4, 2], [4, 4, 1, 1], [4, 3, 3], [4, 3, 2, 1], [4, 3, 1, 1, 1],
                      [4, 2, 2, 2], [4, 2, 2, 1, 1], [4, 2, 1, 1, 1, 1], [4, 1, 1, 1, 1, 1, 1],

              [3, 3, 3, 1], [3, 3, 2, 2], [3, 3, 2, 1, 1], [3, 3, 1, 1, 1, 1],
                      [3, 2, 2, 2, 1], [3, 2, 2, 1, 1, 1], [3, 2, 1, 1, 1, 1, 1],
                      [3, 1, 1, 1, 1, 1, 1, 1],

              [2, 2, 2, 2, 2], [2, 2, 2, 2, 1, 1], [2, 2, 2, 1, 1, 1, 1],
                      [2, 2, 1, 1, 1, 1, 1, 1], [2, 1, 1, 1, 1, 1, 1, 1, 1],

              [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            ]
        end
      end
    end
  end
end

