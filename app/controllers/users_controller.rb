class UsersController < ApplicationController
  attr_reader :user

  before_action :logged_in_user, except: %i(new create show)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if user.save
      @user.send_activation_email
      flash[:info] = t "mailer.info"
      redirect_to root_url
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "users.update_success"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "users.delete"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def save_user user
    log_in user
    remember user
    flash.now[:success] = t "welcome"
    redirect_to user
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users.logged_in_danger"
      redirect_to login_url
    end
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "danger"
    redirect_to root_path
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
