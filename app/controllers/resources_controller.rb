class ResourcesController < ApplicationController
  load_and_authorize_resource

  def index
    @resources = Resource.all
  end

  def edit_ingredient

  end

  def update_ingredient
    if @resource.set_ingredients_from_csv!(params[:ingredients_csv])
      flash[:notice] = "Ingredients Updated"
    else
      flash[:error] = "An error occurred saving: #{@resource.errors}"
    end
    
    redirect_to edit_ingredient_resource_path(@resource)
  end

end