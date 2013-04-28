class TotalDocuments < ActiveRecord::Base
    attr_accessible :language, :number, :category_id
    
    belongs_to :category

    def self.for_language(language)
    	where(language: language).sum(:number)
    end

    def self.for_language_and_category_id(language, category_id)
	    @@num_documents_for ||= {}
	    @@num_documents_for[language] ||= {}
	    @@num_documents_for[language][category_id] ||= where(
	    	language: language, category_id: category_id).first.number
  	end
end