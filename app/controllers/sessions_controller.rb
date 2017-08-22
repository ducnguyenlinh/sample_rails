class SessionsController < ApplicationController
  def new
  end

  def create
    params_session = params[:session]
    user = User.find_by email: params_session[:email].downcase

    if user && user.authenticate(params_session[:password])
      if user.activated?
        log_in user
        params_session[:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
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
