DEFAULT_IDF = 1.5

class KeywordExtractorService

  def initialize(tokens, language, category)
    @tokens = tokens
    @language = language
    @category = category
  end

  # returns idf value for a word
  def get_idfs(words)
    idfs = Hash[words.map { |w|
      [w, DEFAULT_IDF]
    }]
    
    Corpus.for_language(@language).where(category_id: @category, word: words).each { |result|
      idfs[result.word] = Math.log( num_documents_for('en', @category) / (result.count.to_f + 1) )
    }
    idfs
  end

  # returns a hash of rated keywords sorted from the best rated to least from tokens using tf-idf
  def extract
    # create hash of words with number of their instances in tokens excluding stopwords
    words_hash = Hash.new(0)
    @tokens.each { |w| 
      unless w.empty? or stop_words_for('en')[w]
        words_hash[w] += 1 
      end
    }

    idfs_hash = get_idfs(words_hash.keys)

    # calculate tf-idf for each word into keywords array
    keywords = {}
    max_num = words_hash.values.max.to_f
    words_hash.each do |word, num|
      tf = num / max_num
      keywords[word] = (tf * idfs_hash[word]).round(5)
    end

    # return keywords sorted by rank descending
    keywords.sort_by {|k, v| -v}
  end

  private

  def stop_words_for(language)
    @@stop_words_for ||= {}
    @@stop_words_for[language] ||= Hash[Stopword.where(language: language).pluck(:word).map{ |w|
      [w, true]
    }]
  end

  def num_documents_for(language, category)
    @@num_documents_for ||= {}
    @@num_documents_for[language] ||= {}
    @@num_documents_for[language][category] ||= TotalDocuments.where(language: language, category_id: category).first.number
  end
end