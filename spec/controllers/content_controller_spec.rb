require 'spec_helper'

describe ContentController do

  describe "GET 'service'" do
    it "returns readable english content from web page url" do
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
      json['content'].should == File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.content.html')
    end

    it "returns sanitized readable english content from web page url" do
      FakeWeb.register_uri(
        :get, 
        "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/", 
        :body => File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'), 
        :content_type => 'text/html'
      )

      get 'service', 
          url: "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/", 
          format: :json

      response.should be_success
      json = JSON.parse(response.body)
      #File.open(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.content.sanitized', 'w') { |f| f.write  json['content'] } 
      json['content'].should == File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.content.sanitized')
    end

    it "returns readable slovak content from web page url" do
      FakeWeb.register_uri(
        :get, 
        "http://nitra.sme.sk/c/6588534/najstarsiu-rotundu-v-strednej-europe-uvidi-verejnost.html", 
        :body => File.read(File.dirname(__FILE__) + '/../fixtures/article-sme-1.html'), 
        :content_type => 'text/html'
      )

      get 'service', 
          url: "http://nitra.sme.sk/c/6588534/najstarsiu-rotundu-v-strednej-europe-uvidi-verejnost.html", 
          sanitize: false, 
          format: :json

      response.should be_success
      json = JSON.parse(response.body)
      #File.open(File.dirname(__FILE__) + '/../fixtures/article-sme-1.content.html', 'w') { |f| f.write  json['content'] } 
      json['content'].should == File.read(File.dirname(__FILE__) + '/../fixtures/article-sme-1.content.html')
    end

    it "returns sanitized readable slovak content from web page url" do
      FakeWeb.register_uri(
        :get, 
        "http://nitra.sme.sk/c/6588534/najstarsiu-rotundu-v-strednej-europe-uvidi-verejnost.html", 
        :body => File.read(File.dirname(__FILE__) + '/../fixtures/article-sme-1.html'), 
        :content_type => 'text/html'
      )

      get 'service', 
          url: "http://nitra.sme.sk/c/6588534/najstarsiu-rotundu-v-strednej-europe-uvidi-verejnost.html", 
          format: :json

      response.should be_success
      json = JSON.parse(response.body)
      #File.open(File.dirname(__FILE__) + '/../fixtures/article-sme-1.content.sanitized', 'w') { |f| f.write  json['content'] } 
      json['content'].should == File.read(File.dirname(__FILE__) + '/../fixtures/article-sme-1.content.sanitized')
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
    it "returns readable english content from web page source" do
      post 'service', 
            source: File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'), 
            sanitize: false, 
            content_type: 'text/html', 
            format: :json

      response.should be_success
      json = JSON.parse(response.body)
      json['content'].should == File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.content.html')
    end

    it "returns readable slovak content from web page source" do
      post 'service', 
            source: File.read(File.dirname(__FILE__) + '/../fixtures/article-sme-1.html'), 
            sanitize: false, 
            content_type: 'text/html', 
            format: :json

      response.should be_success
      json = JSON.parse(response.body)
      #File.open(File.dirname(__FILE__) + '/../fixtures/article-sme-1.content.html', 'w') { |f| f.write  json['content'] } 
      json['content'].should == File.read(File.dirname(__FILE__) + '/../fixtures/article-sme-1.content.html')
    end

    it "returns error on missing arguments" do
      post 'service', 
            format: :json

      response.should_not be_success
    end
  end

  ##TODO: Test other content types and encodings
end
