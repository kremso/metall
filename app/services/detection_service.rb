class DetectionService
	def initialize(tokens)
		@tokens = tokens
	end

	def category(language)
		chosen_tokens = @tokens.uniq.first(500)
		total_words_for_language = TotalDocuments.where(language: language).sum(:number)
		token_counts = Corpus.for_language(language).where(word: chosen_tokens).map(&:count)
		Category.where(language: language).map { |category|
			total_words_for_language_and_category = TotalDocuments.where(language: language, category_id: category.id).sum(:number)
			token_counts_for_category = Corpus.for_language(language).where(category_id: category.id, word: chosen_tokens).map(&:count)
			
			nominator = token_counts_for_category.inject(0) { |product, token_count_for_category| 
				product + Math.log(token_count_for_category.to_f / total_words_for_language_and_category) 
			} * (total_words_for_language_and_category.to_f / total_words_for_language)

			denominator = token_counts.inject(0) { |product, token_count| 
				product + Math.log(token_count.to_f / total_words_for_language) 
			}
			
			result = nominator / denominator
			result = 0.0 unless result.finite?

			{ score: result, category: category }
		}.sort_by { |score_category|
			score_category[:score]
		}.last[:category]
	end
end