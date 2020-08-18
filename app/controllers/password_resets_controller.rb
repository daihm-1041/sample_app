class PasswordResetsController < ApplicationController
  before_action  :find_user, :valid_user, :check_expiration,
                 only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent_with_password"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_address_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".can_not_be_empty")
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t ".password_has_been_reset"
      redirect_to @user
    else
      flash.now[:danger] = t ".reset_faild"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t ".can_not_find_user"
    redirect_to new_password_reset_url
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash.now[:danger] = t ".pwd_reset.danger.not_valid_user"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_reset_has_expired"
    redirect_to new_password_reset_url
  end
end
