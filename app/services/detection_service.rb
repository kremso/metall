class DetectionService
	def initialize(tokens)
		@tokens = tokens
	end

	def category(language)
		total_words_for_language = TotalDocuments.where(language: language).sum(:number)
		Category.where(language: language).map { |category|
			total_words_for_language_and_category = TotalDocuments.where(language: language, category_id: category.id).sum(:number)
			token_counts_for_category = Corpus.for_language(language).where(category_id: category.id, 
				word: @tokens.uniq).map(&:count)
			token_counts = Corpus.for_language(language).where(word: @tokens.uniq).map(&:count)
			
			nominator = token_counts_for_category.inject(1.0) { |product, token_count_for_category|
				product * token_count_for_category / total_words_for_language_and_category
			} * (total_words_for_language_and_category / total_words_for_language)
			denominator = token_counts.inject(1.0) { |product, token_count|
				product * token_count / total_words_for_language
			}
			nominator / denominator
		}
	end
end