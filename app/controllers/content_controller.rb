class ContentController < ServiceController
  before_filter :prepare_source, only: :service

  respond_to :json

  def service
  	content = Readability::Document.new(@source).content
  	response = { 
  		success: true, 
  		content: content 
  	}
  	respond_with(response, location: nil)
  end
end
