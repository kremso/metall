class Stopword < ActiveRecord::Base

	def self.stop_words_for(language)
	    @@stop_words_for ||= {}
	    @@stop_words_for[language] ||= Hash[Stopword.where(language: language).pluck(:word).map{ |w|
	      [w, true]
	    }]
  end
end