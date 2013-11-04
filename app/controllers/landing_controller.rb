class LandingController < ApplicationController
  
  def index
    
  end

  def signup
    LandingSignup.create({email: params[:email]})
    render :status => 200, :json => {}
  end
  
end