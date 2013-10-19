class LabelsController < ApplicationController
  
  def create    
    label = Label.create_from_file(params[:image])    
    render status: 200, json: {filename: label.filename}
  end
  
  def show
    label = Label.find(params[:id])    
    render status: 200, json: {filename: label.filename}
  end
  
end