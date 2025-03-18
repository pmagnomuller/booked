class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end
  
  def require_logout
    if logged_in?
      flash[:error] = "You are already logged in"
      redirect_to root_path
    end
  end
  
  def authorize_user(resource)
    unless resource.user == current_user
      flash[:error] = "You are not authorized to perform this action"
      redirect_to root_path
    end
  end
end
