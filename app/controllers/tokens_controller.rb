class TokensController < ServiceController
  before_filter :preprocess, only: :service
  before_filter :tokenize, only: :service

  respond_to :json

  def service
  	response = { 
  		success: true, 
  		tokens: @tokens
  	}
  	respond_with(response, location: nil)
  end
end
