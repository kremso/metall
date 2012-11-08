class KeywordsController < ServiceController
  before_filter :prepare_source, only: :service
  before_filter :prepare_max, only: :service

  respond_to :json

  def service
    content = Readability::Document.new(@source).content
    Sanitize.clean!(content)

    keywords = Keyword.new(content).extract

  	response = {
  		success: true,
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
