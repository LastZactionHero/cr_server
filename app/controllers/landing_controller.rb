class LandingController < ApplicationController
  
  def index
    @test_danger = (request.original_fullpath == "/d")
  end

  def signup
    LandingSignup.create({email: params[:email]})
    render :status => 200, :json => {}
  end
  
end