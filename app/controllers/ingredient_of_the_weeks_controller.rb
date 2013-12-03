class IngredientOfTheWeeksController < ApplicationController
  authorize_resource :class => false
  
  layout "admin"
  
  def index
    @ingredient_of_the_weeks = IngredientOfTheWeek.all
  end
  
  def distribute
    @ingredient_of_the_week = IngredientOfTheWeek.find(params[:id])
    success = @ingredient_of_the_week.distribute!
    if success
      flash[:notice] = "Distributing Ingredient of the Week"
    else
      flash[:alert] = "Failed distributing Ingredient of the Week"
    end
    redirect_to ingredient_of_the_weeks_path
  end
  
  def current
    @ingredient_of_the_week = IngredientOfTheWeek.current
    @ingredient = @ingredient_of_the_week.ingredient
  end
end