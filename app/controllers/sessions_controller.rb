class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      activate user
    else
      flash[:warning] = t "wrong_username_or_password"
      redirect_to login_url
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def activate user
    if user.activated?
      log_in user
      check_remember user
      flash[:success] = t "layouts.application.activate_success"
      redirect_to user
    else
      flash[:warning] = t "layouts.application.activate_fail"
      redirect_to root_url
    end
  end
end
