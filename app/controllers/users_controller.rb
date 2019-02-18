class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.user_per
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "welcome"
      redirect_to @user
    else
      flash.now[:danger] = t "fail"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controlers.users.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controlers.users.user_deleted"
    else
      flash[:danger] = t "controlers.users.danger"
    end
    redirect_to users_url
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controlers.users.pls_log_in"
    redirect_to login_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "controlers.users.danger"
    redirect_to signup_path
  end
end
