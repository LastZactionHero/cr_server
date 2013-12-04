class IngredientsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @featured_ingredient = find_featured_ingredient(params[:path])    
    @ingredients = Ingredient.all
  end
  
  def show
    @ingredient = Ingredient.find(params[:id])
    render layout: false
  end
  
  def search
    name = params[:name]    
    @ingredients = name ? Ingredient.where("name like ?", "%#{name}%") : nil

    render layout: false
  end
  
  def unwritten
    @ingredients = Ingredient.where(bulk_description: true).order("name ASC")
    @ingredients = @ingredients.map{|i| i.technical_effects.any? ? i : nil}.compact
  end
  
  def edit
    @ingredient = Ingredient.find(params[:id])
  end
  
  def update
    @ingredient = Ingredient.find(params[:id])
    @ingredient.update_attributes(params[:ingredient])
    redirect_to :action => :unwritten
  end
  
  def delete
    Ingredient.find(params[:id]).destroy
    redirect_to :action => :unwritten
  end
  
  private 
  
  def find_featured_ingredient(name)
    ingredient = Ingredient.find_by_name(name) if name
    ingredient ||= IngredientOfTheWeek.current.ingredient
    ingredient
  end
  
end