require 'spec_helper'

describe MenuUtil do

  context '#new' do
    it "should return a file object from file path" do
      menu_util = MenuUtil.new("/Users/aoshel/Dropbox/personal/table_xi_code_ex/example_files/table_example.txt")
      menu_util.instance_variable_get(:@file_object).should be_a(File)
    end

    it "should return a file object from url" do
      menu_util = MenuUtil.new("http://www.tablexi.com/menu.txt")
      menu_util.instance_variable_get(:@file_object).should be_a(StringIO)
    end

    it "should fail and exit with invalid file from file path" do
      expect { menu_util = MenuUtil.new("/User/dev/text.txt") }.to raise_error
    end

    it "should and exit with invalid file object from url" do
      expect { menu_util = MenuUtil.new("/User/dev/text.txt") }.to raise_error
    end
  end

  context 'helper method' do
    let(:menu_util) { MenuUtil.new("/Users/aoshel/Dropbox/personal/table_xi_code_ex/example_files/table_example.txt") }
    it 'centsify should return dollar string as cents' do
      menu_util.centsify("$15.05\n").should eql(1505)
      menu_util.centsify(" 5.05\n ").should eql(505)
      menu_util.centsify(" 5 .05 ").should eql(505)
    end

    it 'parse_total should return dollar string on frist line as cents' do
      ## from table_example.txt first line is $15.05
      menu_util.parse_total.should eql(1505)
    end

    it 'assemble menu should return total as cents and array of menu items' do
      menu = menu_util.assemble_menu
      menu.first.should be_a(Fixnum)
      menu.last.each do |m|
        m.price.should be_a(Fixnum)
        m.should be_a_kind_of(MenuUtil::MenuItem)
      end
    end
  end
end
