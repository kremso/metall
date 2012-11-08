require 'spec_helper'

describe KeywordsController do

  describe "GET 'service'" do
    it "returns keywords with rating from web page url in english" do
      FakeWeb.register_uri(
        :get,
        "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/",
        :body => File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'),
      )

      get 'service',
        url: "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/",
        format: :json

      response.should be_success
      json = JSON.parse(response.body)
      json['keywords'].should == JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.keywords.json'))
    end

    it "returns maximum number of keywords with rating from web page url in english" do
      FakeWeb.register_uri(
        :get,
        "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/",
        :body => File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'),
      )

      get 'service',
        url: "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/",
        max: 5,
        format: :json

      response.should be_success
      json = JSON.parse(response.body)
      json['keywords'].should == JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.keywords.json')).first(5)
    end

    it "returns error on missing arguments" do
      get 'service',
        format: :json

      response.should_not be_success
      json = JSON.parse(response.body)
      json['success'].should == false
      json['error_message'].should == 'You have to use either url or source argument.'
    end
  end

  describe "POST 'service'" do
      it "returns keywords with rating from web page url in english" do
        post 'service',
          source: File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'),
          format: :json

        response.should be_success
        json = JSON.parse(response.body)
        json['keywords'].should == JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.keywords.json'))
      end

      it "returns maximum number of keywords with rating from web page url in english" do
        post 'service',
          source: File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'),
          max: 5,
          format: :json

        response.should be_success
        json = JSON.parse(response.body)
        json['keywords'].should == JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.keywords.json')).first(5)
      end

      it "returns error on missing arguments" do
        post 'service',
          format: :json

        response.should_not be_success
        json = JSON.parse(response.body)
        json['success'].should == false
        json['error_message'].should == 'You have to use either url or source argument.'
      end
    end

end