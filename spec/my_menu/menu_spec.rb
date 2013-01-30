require 'spec_helper'

module MyMenu
  describe Menu do
    let(:output) { double('output').as_null_object }
    let(:menu) { Menu.new(output) }

    describe "#start" do
      it "sends a welcome message" do
        output.should_receive(:puts).with('Welcome to My Menu!')
        menu.greeting
      end
      it "prompts for file or url" do
        output.should_receive(:puts).with('Please Enter a File Location or URL:')
        menu.greeting
      end
    end

    describe "#data file entry" do
      it "sends data file results to output" do
        file_resource = menu.parse_data_file("http://www.tablexi.com/menu.txt")
        file_resource.should be_a_kind_of(FileResource)
      end
    end
  end
end

