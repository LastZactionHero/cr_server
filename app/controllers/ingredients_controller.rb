class IngredientsController < ApplicationController
  
  def index
    @ingredients = Ingredient.all
  end
  
  def show
    @ingredient = Ingredient.find(params[:id])
  end
  
  def search
    name = params[:name]    
    @ingredients = name ? Ingredient.where("name like ?", "%#{name}%") : nil
  end
  
end