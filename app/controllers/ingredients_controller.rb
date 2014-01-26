class IngredientsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @featured_ingredient = find_featured_ingredient(params[:path])    
    @ingredients = Ingredient.visible
  end
  
  def show
    @ingredient = Ingredient.find(params[:id])
    render layout: false
  end
  
  def search
    name = params[:name]    
    @ingredients = name ? Ingredient.visible.where("name like ?", "%#{name}%") : nil

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
    
    @ingredient.visible = true
    @ingredient.save
    
    redirect_to :action => :unwritten
  end
  
  def delete
    Ingredient.find(params[:id]).destroy
    redirect_to :action => :unwritten
  end

  def proofread
    page_length = 20
    @page = params[:page].to_i || 1

    @ingredients = Ingredient.visible.not_proofed.offset(@page * page_length).limit(page_length)
    @pages = (Ingredient.visible.not_proofed.count.to_f / 20.to_f).floor
  end

  def proof
    @ingredient = Ingredient.find(params[:id])
    @ingredient.update_attributes(params[:ingredient])
    @ingredient.proofed!

    redirect_to :action => :proofread
  end
  
  private 
  
  def find_featured_ingredient(name)
    ingredient = Ingredient.find_by_name(name) if name
    ingredient ||= IngredientOfTheWeek.current.ingredient
    ingredient
  end
  
end