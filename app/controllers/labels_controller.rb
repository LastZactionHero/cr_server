class LabelsController < ApplicationController
  
  def create    
    label = Label.create_from_file(params[:image])    
    label.queue!
    render status: 200, json: {id: label.id}
  end
  
  def show
    label = Label.find(params[:id])    
    render status: 200, json: {
      id: label.id,
      status: label.status,
      debug: label.ingredient_string,
      ingredients: [
        ingredient: {
          id: 1,
          name: "Ingredient Name",
          description: "Description"
        },
        ingredient: {
          id: 2,
          name: "Ingredient Name",
          description: "Description"
        }        
      ]                 
    }
  end
  
end