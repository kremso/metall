class DetectionService
	def initialize(tokens)
		@tokens = tokens
	end

	def category(language)
		chosen_tokens = @tokens.uniq.shuffle.first(200)
		total_documents_for_language = TotalDocuments.where(language: language).sum(:number)
		Category.where(language: language).map { |category|
			token_counts_for_category = Corpus.for_language(language).where(category_id: category.id, word: chosen_tokens).map(&:count)
			total_words_for_language_and_category = Corpus.for_language(language).where(category_id: category.id).count
			total_documents_for_language_and_category = TotalDocuments.where(language: language, category_id: category.id).sum(:number)
			
			nominator = token_counts_for_category.inject(0) { |product, token_count_for_category| 
				product + Math.log(token_count_for_category.to_f / total_words_for_language_and_category) 
			} + Math.log(total_documents_for_language_and_category.to_f / total_documents_for_language)

			{ score: nominator.finite? ? nominator : 0.0, category: category }
		}.sort_by { |score_category|
			score_category[:score]
		}#.last[:category]
	end
end