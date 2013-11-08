require 'ingredient_of_the_week_notifier'

class IngredientOfTheWeek < ActiveRecord::Base
  attr_accessible :distributed, :distributed_at, :ingredient_id
  
  belongs_to :ingredient
  
  validates_presence_of :ingredient_id
    
  default_scope order("distributed_at DESC")
  scope :distributed, -> { where(distributed: true) }
  
  def self.current
    self.distributed.first
  end
  
  def distribute!
    return false if distributed
    
    IngredientOfTheWeekNotifier.broadcast(ingredient)
    
    self.distributed = true
    self.distributed_at = DateTime.now
    save
  end
  
end
