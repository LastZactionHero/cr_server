class Match < ActiveRecord::Base
  attr_accessible :ingredient_id, :label_id, :similarity
  
  belongs_to :ingredient
  belongs_to :label
end
