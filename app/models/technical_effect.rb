class TechnicalEffect < ActiveRecord::Base
  attr_accessible :abbreviation, :description, :name
  
  has_and_belongs_to_many :ingredients
end
