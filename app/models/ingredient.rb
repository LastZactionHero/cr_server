class Ingredient < ActiveRecord::Base
  attr_accessible :description, :name
  
  has_many :matches
  has_many :labels, :through => :matches
  has_and_belongs_to_many :technical_effects
  has_and_belongs_to_many :regulatory_statuses
  
  validates_uniqueness_of :name
  
  default_scope order("name ASC")
   
  def self.name_list
    Ingredient.pluck(:name)
  end
  
end
