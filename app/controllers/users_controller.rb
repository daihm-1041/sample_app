class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.page(params[:page]).per Settings.number.page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      remember @user
      flash[:success] = t "layouts.application.inform_success"
      redirect_to @user
    else
      flash[:danger] = t "layouts.application.inform_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.new.profile_updated"
      redirect_to @user
    else
      flash[:success] = t "users.new.profile_updated_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.new.user_deleted"
    else
      flash[:danger] = t "users.new.user_deleted_err"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.new.inform_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to current_user unless current_user? @user
  end

  def find_user
    @user = User.find_by id: params[:id] if params[:id]
    return if @user

    flash[:danger] = t "layouts.application.invalid_user"
    redirect_to root_url
  end
end
