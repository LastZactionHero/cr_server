class IngredientsController < ApplicationController
  load_and_authorize_resource

  def index
    @featured_ingredient = find_featured_ingredient(params[:path])
    @ingredients = Ingredient.visible.order("name ASC")
  end

  def show
    @ingredient.increment_view_count!
    render layout: false
  end

  def search
    name = params[:name]
    @ingredients = name.present? ? Ingredient.visible.where("name like ?", "%#{name}%").order("name ASC") : Ingredient.visible.most_popular.limit(20)

    name ||= ""

    @ingredients.sort!{|a,b|
        a.name.downcase.index(name.downcase) <=> b.name.downcase.index(name.downcase) }

    render layout: false
  end

  def unwritten
    @ingredients = Ingredient.where(bulk_description: true).order("name ASC")
    @ingredients = @ingredients.map{|i| i.technical_effects.any? ? i : nil}.compact
  end

  def edit
  end

  def update
    @ingredient.update_attributes(params[:ingredient])

    @ingredient.visible = true
    @ingredient.save

    redirect_to :action => :unwritten
  end

  def delete
    @ingredient.destroy
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
