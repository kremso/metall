class TokensController < ServiceController
  before_filter :prepare_content, only: :service
  before_filter :prepare_tokens, only: :service

  respond_to :json
  respond_to :xml

  def service
  	response = { 
  		success: true, 
  		tokens: @tokens
  	}
  	respond_with(response, location: nil)
  end
end
