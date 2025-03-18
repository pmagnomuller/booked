class UsersController < ApplicationController
  before_action :require_logout, only: [:new, :create]
  before_action :require_login, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user_profile, only: [:edit, :update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Account created successfully!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @properties = @user.properties
    @bookings = @user.bookings.includes(:property).order(start_date: :desc)
  end

  def edit
    # Just render the edit form
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated successfully!"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :bio, :avatar)
  end
  
  def authorize_user_profile
    unless @user == current_user
      flash[:error] = "You are not authorized to view this profile"
      redirect_to root_path
    end
  end
end
