# encoding: UTF-8

require 'spec_helper'

describe WelcomeController do

  it "should show welcome page" do
    visit root_path

    page.should have_content 'Text metadata extraction service from URLs or text content.'
  end
end
