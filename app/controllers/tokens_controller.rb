class TokensController < ServiceController
  before_filter :preprocess_input, only: :service

  respond_to :json

  def service
  	response = { 
  		success: true, 
  		tokens: @tokens
  	}
  	respond_with(response, location: nil)
  end
end
