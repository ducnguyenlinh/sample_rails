class SessionsController < ApplicationController
  def new
  end

  def create
    params_session = params[:session]
    user = User.find_by email: params_session[:email].downcase

    if user && user.authenticate(params_session[:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t "invalid_email"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
