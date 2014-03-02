class KeywordsController < ServiceController
  before_filter :prepare_content, only: :service
  before_filter :prepare_language, only: :service
  before_filter :prepare_tokens, only: :service
  before_filter :prepare_category, only: :service
  before_filter :prepare_limit, only: :service

  before_filter :prepare_request, only: :batch_result
  before_filter :prepare_documents, only: :batch_service

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
    bkr = BatchKeywordRequest.create(callback_url: params[:callback_url])

    @documents.each do |d|
      dk = DocumentKeyword.create(batch_keyword_request_id: bkr.id, options: d)
      dk.delay.extract!
    end

    response = {
      success: true,
      uid: bkr.uid
    }

    ru_json = batch_keywords_result_url(format: 'json', uid: bkr.uid)
    ru_xml = batch_keywords_result_url(format: 'json', uid: bkr.uid)

    respond_to do |format|
      format.json { render json: response.merge(result_url: ru_json).to_json, location: ru_json, status: 202 }
      format.json { render json: response.merge(result_url: ru_xml).to_xml, location: ru_xml, status: 202 }
    end
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
      @request = BatchKeywordRequest.find_by_uid(params[:uid])
      raise 'Bad request UID.' if @request.nil?
    end

    def prepare_documents
      @documents = params[:documents]
      raise 'No documents received.' unless @documents.present?
    end

end
