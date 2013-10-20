class Ingredient < ActiveRecord::Base
  attr_accessible :description, :name
  
  has_and_belongs_to_many :labels
  
  def self.name_list
    Ingredient.pluck(:name)
  end
  
end
