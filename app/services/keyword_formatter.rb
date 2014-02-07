class KeywordFormatter
  def self.format(keywords, limit)
    kws_array = []
    keywords.first(limit).each do |word, rank, idf|
      kws_array << { keyword: word, rating: rank, idf: idf }
    end
    kws_array
  end
end