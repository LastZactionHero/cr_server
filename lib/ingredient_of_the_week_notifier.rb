class IngredientOfTheWeekNotifier

  def self.broadcast(ingredient, options = {})
    notification = {
      :aps => {
        :alert => alert_message(ingredient),
        :alert_type => "featured_ingredient",
        :ingredient_id => ingredient.id,
        :ingredient_name => ingredient.name
      }
    }
    Urbanairship.broadcast_push(notification)
  end
  
  private
  
  def self.alert_message(ingredient)
    ingredient.name
  end
  
end