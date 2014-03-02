class ServiceController < ApplicationController
  before_filter :prepare_options

  protected

    def render_unsupported
      respond_to do |format|
        format.all { render text: "Unsupported format. We support JSON and XML.", status: 415 }
      end
    end

	  def prepare_options
      options = params.except(:controller, :action, :format)
      options.each_key { |key|
        options[key] = false if options[key] == 'false'
        options[key] = true  if options[key] == 'true'
      }

      @options_preparator = OptionsPreparator.new(options)
	  end

    def prepare_language
      @language = @options_preparator.language
    end

    def prepare_category
    	@category = @options_preparator.category(@language)
    end

    def prepare_limit
      @limit = @options_preparator.limit
    end

    def prepare_content
      @content = @options_preparator.content
    end

    def prepare_tokens
      @tokens = @options_preparator.tokens(@language, @content)
    end

	rescue_from StandardError do |error|
    if Rails.env.development?
      raise error
		elsif %w{ArgumentError NoMethodError NameError}.include?(error.class.name)
			raise error
		else
	  		response = {
	  			success: false,
	  			error_type: error.class.name,
	  			error_message: error.message
	  		}
	  		respond_with(response, location: nil, status: 406)
	  	end
  	end
end
