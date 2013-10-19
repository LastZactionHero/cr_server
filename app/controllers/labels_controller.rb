class LabelsController < ApplicationController
  
  def create    
    label = Label.create_from_file(params[:image])    
    render status: 200, json: {filename: label.filenlame}
  end
  
  def show
    label = Label.find(params[:id])    
    render status: 200, json: {filename: label.filenlame}
  end
  
end