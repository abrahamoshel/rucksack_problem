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
      let(:my_menu) { [1,2,3] }

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
          menu.suggest_items(my_menu, total).should == [[1]]
        end

        it "should have two suggestions amount of 2" do
          total += 1
          menu.suggest_items(my_menu, total).should == [[2], [1, 1]]
        end

        it "should have three suggestions amount of 3" do
          total += 1
          menu.suggest_items(my_menu, total).should == [[3], [2, 1], [1, 1, 1]]
        end
        it "should have four suggestions amount of 4" do
          total += 1
          my_menu.replace([1, 2, 3, 4])
          menu.suggest_items(my_menu, total).should == [[4], [3, 1], [2, 2], [2, 1, 1], [1, 1, 1, 1]]
        end
        it "should have four suggestions amount of 4" do
          total = 5
          my_menu.replace([1, 2, 3, 4])
          menu.suggest_items(my_menu, total).should =~ [[4, 1], [3, 2], [3, 1, 1], [2, 2, 1], [2, 1, 1, 1], [1, 1, 1, 1, 1]]
        end
      end
    end
  end
end

