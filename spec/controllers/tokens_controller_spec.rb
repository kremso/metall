require 'spec_helper'

describe TokensController do

  describe "GET 'service'" do
    it "returns stemmed tokens from web page url" do
      FakeWeb.register_uri(
        :get, 
        "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/", 
        :body => File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'), 
        :content_type => 'text/html'
      )

      get 'service', 
          url: "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/", 
          sanitize: false, 
          format: :json

      response.should be_success
      json = JSON.parse(response.body)
      tokens = json['tokens']
      tokens.count.should == 1037
      tokens.should include 'starvat'
      tokens.should include 'dehydr'
      tokens.should_not include 'starvation'
      tokens.should_not include 'dehydration'
      tokens.should include 'world'
    end
  end
end
