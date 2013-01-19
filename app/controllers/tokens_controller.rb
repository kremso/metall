class TokensController < ServiceController
  before_filter :prepare_content, only: :service

  respond_to :json

  def service
  	response = { 
  		success: true, 
  		tokens: @tokens
  	}
  	respond_with(response, location: nil)
  end
end
