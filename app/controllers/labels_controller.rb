class LabelsController < ApplicationController
  before_filter :find_label_or_fail, only: [:show, :rate]
  
  def create    
    @label = Label.create_from_file(params[:image])    
    @label.queue!
  end
  
  def show
    @label = Label.find(params[:id])
  end
  
  def rate
    @label = Label.find(params[:id])
    @label.update_attributes({rating: params[:rating]})
    
    if @label.errors.any?
      render :status => 400, :json => {errors: @label.errors}
    else
      render :status => 200, :json => {}
    end
  end
  
  private
  
  def find_label_or_fail
    @label = Label.find params[:id]    
    render :status => 404, :json => {} and return unless @label
  end
  
end