class DocumentKeywordExtractor
  
  def initialize(options)
    options_preparator = OptionsPreparator.new(options)

    @language = options_preparator.language
    @category = options_preparator.category(@language)
    @limit = options_preparator.limit
    
    @url = options[:url]
    content = options_preparator.content
    @tokens = options_preparator.tokens(@language, content)
  end

  def extract
    kws = KeywordExtractorService.new(@tokens, @language, @category.id).extract

    {
      success: true,
      url: @url,
      language: @language,
      category: @category.name,
      keywords: KeywordFormatter.format(kws, @limit),
    }
  end

end
