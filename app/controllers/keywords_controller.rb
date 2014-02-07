class KeywordsController < ServiceController
  before_filter :prepare_content, only: :service
  before_filter :prepare_language, only: :service
  before_filter :prepare_tokens, only: :service
  before_filter :prepare_category, only: :service
  before_filter :prepare_limit, only: :service

  before_filter :prepare_request, only: :batch_result

  respond_to :json
  respond_to :xml

  def service
    keywords = KeywordExtractorService.new(@tokens, @language, @category.id).extract

  	response = {
  		success: true,
      language: @language,
      category: @category.name,
  		keywords: KeywordFormatter.format(keywords, @limit)
  	}
  	respond_with(response, location: nil)
  end

  def batch_service
    request = BatchKeywordRequest.create(callback_url: params[:callback_url])

    params[:documents].each do |d|
      dk = DocumentKeyword.create(batch_keyword_request_id: request.id, options: d)
      dk.delay.extract!
    end

    response = {
      success: true,
      uid: request.uid,
      callback_url: request.callback_url,
    }
    respond_with(response, location: nil)
  end

  def batch_result
    if @request.done?
      response = {
        success: true,
        uid: @request.uid,
        documents_results: @request.results
      }
    else
      response = {
        success: false,
        uid: @request.uid,
        documents_requested: @request.num_documents_requested,
        documents_done: @request.num_documents_done,
      }
    end
    respond_with(response, location: nil)
  end

  private

    def prepare_request
      @request = BatchKeywordRequest.where(uid: params[:uid])
      if @request.nil?
        raise 'Bad request UID.'
      else
        @request = @request.first
      end
    end
end
