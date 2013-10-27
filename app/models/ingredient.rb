class Ingredient < ActiveRecord::Base
  attr_accessible :description, :name
  
  has_many :matches
  has_many :labels, :through => :matches
  
  default_scope order("name ASC")
   
  def self.name_list
    Ingredient.pluck(:name)
  end
  
end
