class DetectionService
	def initialize(tokens)
		@tokens = tokens
	end

	def category(language)
		category_scores(language).sort_by { |score_category|
			score_category[:score]
		}.last[:category]
	end

	def category_scores(language)
		tokens_hash = Hash.new(0)
	    @tokens.each { |w| 
	      unless w.empty? or Stopword.stop_words_for(language)[w]
	        tokens_hash[w] += 1 
	      end
	    }

		first = tokens_hash.sort_by{ |token, count| 
			count 
		}.reverse.map { |token, count| 
			token
		}.first(100)

		Category.where(language: language).map { |category|
			token_counts_for_category = {}
			Corpus.for_language(language).where(category_id: category.id, 
				word: first).each { |result|
				token_counts_for_category[result.word] = result.count
			}
			total_documents_for_language_and_category = TotalDocuments.for_language_and_category_id(
				language, category.id)
			
			nominator = token_counts_for_category.inject(0) { |product, token_count_for_category| 
				token = token_count_for_category[0]
				count_for_category = token_count_for_category[1]
				product + tokens_hash[token] * Math.log(count_for_category.to_f / total_documents_for_language_and_category) 
			} + Math.log(total_documents_for_language_and_category.to_f / TotalDocuments.for_language(language))

			{ 
				score: nominator.finite? ? nominator : 0.0, 
				category: category 
			}
		}
	end
end