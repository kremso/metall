class ContentController < ServiceController
  before_filter :prepare_content, only: :service

  respond_to :json
  respond_to :xml

  def service
  	response = { 
  		success: true, 
  		content: @content
  	}
  	respond_with(response, location: nil)
  end
end
