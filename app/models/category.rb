class Category < ActiveRecord::Base
  attr_accessible :language, :name
  
  has_many :corpus_en
end