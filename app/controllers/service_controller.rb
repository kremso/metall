# encoding: utf-8

class ServiceController < ApplicationController

  protected

	  def preprocess
	  	@options = params.except(:controller, :action, :format)
	  	@options.each_key { |key|
	  		@options[key] = false if @options[key] == 'false'
	  	}

	  	# source or url
	  	if @options[:source]
	  		@content = @options[:source]
	  	elsif @options[:url]
	  		response = Faraday.get(@options[:url])
	  		@content = response.body
	  		@options[:content_type] ||= response.headers['content-type']
	  	else
	  		raise 'You have to use either url or source argument.'
	  	end

	  	# html source?
	  	if @options[:content_type] and (@options[:content_type].starts_with?('text/html') or @options[:content_type].starts_with?('application/xhtml+xml'))
	  		# set defaults
	  		@options[:extract_content] = true if @options[:extract_content].nil?
	  		@options[:sanitize] = true if @options[:sanitize].nil?

  			# nokogiri detects proper input encoding
  			@content = Nokogiri::HTML(@content).inner_html
  		end

  		if @options[:extract_content]
  			@content = Readability::Document.new(@content).content
  		end

  		# convert to utf-8
		@options[:encoding] ||= @content.encoding.name
	  	if @options[:encoding] != 'UTF-8'
			converter = Encoding::Converter.new(@options[:encoding], 'UTF-8')
			@content = converter.convert(@content)
			converter.finish
  		else
  			@content.force_encoding('UTF-8')
  		end

  		if @options[:sanitize]
  			Sanitize.clean!(@content)
  		end
    end

    def tokenize
	    @tokens = @content.downcase.split.map { |w| 
	    	w.force_encoding('UTF-8').gsub('’', '\'').gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '') 
	    }

	    unless @options[:stem] == false
	    	@tokens = @tokens.map(&:stem)
	    end

	    if @options[:lemmatize]
	    	lemmatization_service = LemmatizationService.new
	    	@tokens = lemmatization_service.lemmatize(@tokens)
	    end
    end

    def language
    	@language = @options[:language].present? ? @options[:language] : 'en'
    	raise "Unknown language #{@language}" unless %w{en}.include? @language
    end

    def prepare_max
      if params[:max]
        @max = params[:max]
      else
        @max = 10
      end
    end

	rescue_from StandardError do |error|
		if %w{ArgumentError NoMethodError NameError}.include?(error.class.name)
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
