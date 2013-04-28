require 'spec_helper'

describe KeywordsController do

  before do
    CorpusEn.create({ category_id: 1, word: 'to', count: 6332195 }, without_protection: true)
    CorpusEn.create({ category_id: 1, word: 'you', count: 3085642 }, without_protection: true)
    CorpusEn.create({ category_id: 1, word: 'they', count: 1865844 }, without_protection: true)
    CorpusEn.create({ category_id: 1, word: 'not', count: 1638883 }, without_protection: true)
    CorpusEn.create({ category_id: 1, word: 'go', count: 1151045 }, without_protection: true)
    CorpusEn.create({ category_id: 4, word: 'her', count: 969591 }, without_protection: true)
    CorpusEn.create({ category_id: 3, word: 'as', count: 829018 }, without_protection: true)
    CorpusEn.create({ category_id: 2, word: 'think', count: 772787 }, without_protection: true)
    CorpusEn.create({ category_id: 1, word: 'take', count: 670745 }, without_protection: true)

    Stopword.create({ language: 'en', word: 'a' }, without_protection: true)
    Stopword.create({ language: 'en', word: 'able' }, without_protection: true)
    Stopword.create({ language: 'en', word: 'to' }, without_protection: true)

    TotalDocuments.create({ language: 'en', category_id: 1, number: '6461423' }, without_protection: true)

    Category.create language: 'en', name: 'default'
  end

  describe "GET 'service'" do
    it "returns keywords with rating from web page url in english" do
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
      json['keywords'].count.should == 10
      json['keywords'].first.should == { "keyword" => "the", "rating" => 1.5 }
      json['keywords'].second.should == { "keyword" => "and", "rating" => 0.73973 }
    end

    it "returns keywords using stemming" do
      FakeWeb.register_uri(
        :get,
        "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/",
        :body => File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'),
        :content_type => 'text/html'
      )

      get 'service',
        url: "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/",
        format: :json, 
        limit: 100

      response.should be_success
      json = JSON.parse(response.body)
      keywords = json['keywords'].map { |kw|
        kw['keyword']
      }

      keywords.should include 'starvat'
      keywords.should include 'dehydr'
      keywords.should_not include 'starvation'
      keywords.should_not include 'dehydration'
      keywords.should include 'world'
    end

    it "returns maximum number of keywords with rating from web page url in english" do
      FakeWeb.register_uri(
        :get,
        "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/",
        :body => File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'),
        :content_type => 'text/html'
      )

      get 'service',
        url: "http://techcrunch.com/2012/11/03/quick-tie-the-rafts-together/",
        limit: 5, 
        format: :json

      response.should be_success
      json = JSON.parse(response.body)
      json['keywords'].count.should == 5
      json['keywords'].first.should == { "keyword" => "the", "rating" => 1.5 }
      json['keywords'].second.should == { "keyword" => "and", "rating" => 0.73973 }
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
          content_type: 'text/html', 
          format: :json

        response.should be_success
        json = JSON.parse(response.body)
        json['keywords'].count.should == 10
        json['keywords'].first.should == { "keyword" => "the", "rating" => 1.5 }
        json['keywords'].second.should == { "keyword" => "and", "rating" => 0.73973 }
      end

      it "returns maximum number of keywords with rating from web page url in english" do
        post 'service',
          source: File.read(File.dirname(__FILE__) + '/../fixtures/article-techcrunch-1.html'),
          limit: 5,
          content_type: 'text/html', 
          format: :json

        response.should be_success
        json = JSON.parse(response.body)
        json['keywords'].count.should == 5
        json['keywords'].first.should == { "keyword" => "the", "rating" => 1.5 }
        json['keywords'].second.should == { "keyword" => "and", "rating" => 0.73973 }
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