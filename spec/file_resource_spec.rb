require 'spec_helper'

describe FileResource, "#start" do
  it "sends a welcome message" do
    pending
    output.should_receive(:puts).with('Welcome to My Menu!')
    menu.greeting
  end
  it "prompts for file or url" do
    pending
    output.should_receive(:puts).with('Please Enter a File Location or URL:')
    menu.greeting
  end
end
