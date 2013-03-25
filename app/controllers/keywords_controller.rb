class KeywordsController < ServiceController
  before_filter :prepare_content, only: :service
  before_filter :prepare_tokens, only: :service
  before_filter :prepare_language_and_category, only: :service
  before_filter :prepare_limit, only: :service

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
      keywords.first(@limit).each do |k, r|
        kws_array << { keyword: k, rating: r }
      end
      kws_array
    end
end
