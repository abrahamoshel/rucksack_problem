require 'spec_helper'

describe MenuUtil, "#start" do
  it "sends a welcome message" do
    pending "not the correct spec for testing FileResource"
    output.should_receive(:puts).with('Welcome to My Menu!')
    menu.greeting
  end
  it "prompts for file or url" do
    pending "not the correct spec for testing FileResource"
    output.should_receive(:puts).with('Please Enter a File Location or URL:')
    menu.greeting
  end
end
