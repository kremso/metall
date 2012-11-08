class ServiceController < ApplicationController

  protected

	  def prepare_source
	  	if params[:source]
	  		@source = params[:source]
	  	elsif params[:url]
	  		response = Faraday.get(params[:url])
	  		@source = response.body
	  	else
	  		raise_error 'You have to use either url or source argument.'
	  	end
    end

    def prepare_max
      if params[:max]
        @max = params[:max]
      else
        @max = 10
      end
    end

	  def raise_error(message)
	  	response = { 
	  		success: false, 
	  		error_message: message
	  	}
	  	respond_with(response, location: nil, status: 406)
	  end
end
