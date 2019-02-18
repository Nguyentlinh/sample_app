class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      set_cookie_sessions user
    else
      flash.now[:danger] = t "email_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def set_cookie_sessions user
    log_in user

    if params[:session][:remember_me] == Settings.string_one
      remember(user)
    else
      forget(user)
    end
    redirect_back_or user
  end
end
