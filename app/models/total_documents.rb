class TotalDocuments < ActiveRecord::Base
    attr_accessible :language, :number, :category_id
    
    belongs_to :category
end