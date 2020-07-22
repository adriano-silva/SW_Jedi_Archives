class SessionsController < ApplicationController

  skip_before_action :authorized, only: [:new, :create]

  # Creating session for user
  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to '/home'
    else
      redirect_to '/login'
    end
  end

end
