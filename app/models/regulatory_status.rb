class RegulatoryStatus < ActiveRecord::Base
  attr_accessible :abbreviation, :description, :name
  
  has_and_belongs_to_many :ingredients
  
  validates_uniqueness_of :abbreviation
  validates_uniqueness_of :name
end
