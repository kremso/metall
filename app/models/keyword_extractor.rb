DEFAULT_IDF = 1.5

class KeywordExtractor
  def initialize(tokens)
    @stopwords = Stopword.where(language: 'en').pluck(:word)
    @num_documents = TotalDocuments.where(language: 'en').first.number

    @tokens = tokens
  end

  # returns idf value for a word
  def get_idf(word)
    value = Corpus.where(language: 'en', word: word).first
    if value.nil?
      DEFAULT_IDF
    else
      Math.log( @num_documents / (value.count.to_f + 1) )
    end
  end

  # returns a hash of rated keywords sorted from the best rated to least from tokens using tf-idf
  def extract
    # split source into array of words excluding stopwords
    words = @tokens
    words.delete_if { |w| w.empty? || @stopwords.include?(w) }

    # create hash of words with number of their instances in tokens
    words_hash = Hash.new(0)
    words.each { |w| words_hash[w] += 1 }

    # calculate tf-idf for each word into keywords array
    keywords = {}
    max_num = words_hash.values.max.to_f
    words_hash.each do |word, num|
      tf = num / max_num
      idf = get_idf(word)
      keywords[word] = (tf * idf).round(5)
    end

    # return keywords sorted by rank descending
    keywords.sort_by {|k, v| -v}
  end
end