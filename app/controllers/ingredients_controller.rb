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
  
  def unwritten
    @ingredients = Ingredient.where(bulk_description: true).order("name ASC")
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
  
end