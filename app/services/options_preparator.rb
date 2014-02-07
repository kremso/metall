# encoding: utf-8

class OptionsPreparator

  def initialize(options)
    @options = options
  end

  def language
    if @options[:language].present?
      language = @options[:language] 
    else
      language = 'en'
    end

    raise "Unknown language #{@language}" unless %w{en sk}.include?(language)

    language
  end

  def category(language)
    if @options[:category].present?
      category = Category.where(language: language, name: @options[:category]).first
      raise "Unknown category #{@options[:category]} for language #{@language}." unless category
    else
      category = Category.where(language: language).first
      raise "No category for language #{@options[:category]}." unless category
    end

    category
  end

  def limit
    if @options[:limit].present?
      @options[:limit].to_i
    else
      10
    end
  end

  def content
    # source or url
    if @options[:source]
      content = @options[:source]
    elsif @options[:url]
      response = Faraday.get(@options[:url])
      content = response.body
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
      content = Nokogiri::HTML(content).inner_html
    end

    if @options[:extract_content]
      content = Readability::Document.new(content).content
    end

    # convert to utf-8
    @options[:encoding] ||= content.encoding.name
    if @options[:encoding] != 'UTF-8'
      converter = Encoding::Converter.new(@options[:encoding], 'UTF-8')
      content = converter.convert(content)
      converter.finish
    else
      content.force_encoding('UTF-8')
    end

    if @options[:sanitize]
      Sanitize.clean!(content)
    end

    content
  end

  def tokens(language, content)
    tokens = content.downcase.split.map { |w| 
      w.force_encoding('UTF-8').gsub('’', '\'').gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '') 
    }

    case language
      when 'en'
        tokens = tokens.map(&:stem)
      when 'sk'
        unless @options[:lematize] == false # undocumented
          lemmatization_service = LemmatizationService.new
          tokens = lemmatization_service.lemmatize(tokens)
        end
    end

    tokens
  end

end
