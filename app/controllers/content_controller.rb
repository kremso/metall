class ContentController < ServiceController
  before_filter :preprocess_input, only: :service

  respond_to :json

  def service
  	response = { 
  		success: true, 
  		content: @content
  	}
  	respond_with(response, location: nil)
  end
end
