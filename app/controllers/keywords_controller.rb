class KeywordsController < ServiceController
  before_filter :preprocess, only: :service
  before_filter :tokenize, only: :service
  before_filter :language, only: :service
  before_filter :prepare_max, only: :service

  respond_to :json

  def service
    keywords = KeywordExtractor.new(@tokens, @language, @category.id).extract

  	response = {
  		success: true,
      language: @language, 
      category: @category.name,
  		keywords: format_keywords(keywords)
  	}
  	respond_with(response, location: nil)
  end

  private
    def format_keywords(keywords)
      kws_array = []
      keywords.first(@max).each do |k, r|
        kws_array << { keyword: k, rating: r }
      end
      kws_array
    end
end
