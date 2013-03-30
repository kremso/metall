# encoding: utf-8

class ServiceController < ApplicationController
  before_filter :prepare_options

  protected

  	  def prepare_options
  	  	@options = params.except(:controller, :action, :format)
	  	@options.each_key { |key|
	  		@options[key] = false if @options[key] == 'false'
	  	}
  	  end

	  def prepare_content
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

    def prepare_tokens
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

    def prepare_language_and_category
    	if @options[:language].present?
    		@language = @options[:language] 
    	else
    		@language = 'en'
    	end
    	raise "Unknown language #{@language}" unless %w{en}.include? @language

    	if @options[:category].present?
    		@category = Category.where(language: @language, name: @options[:category]).first
    		raise "Unknown category #{@options[:category]} for language #{@language}." unless @category
    	else
    		@category = Category.where(language: @language).first
    		raise "No category for language #{@options[:category]}." unless @category

    		# detection = DetectionService.new(@tokens)
    		# @category = detection.category(@language)
    		# raise @category.to_yaml
    	end
    end

    def prepare_limit
      if params[:limit].present?
        @limit = params[:limit]
      else
        @limit = 10
      end
    end

	rescue_from StandardError do |error|
    if not Rails.env.production?
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
