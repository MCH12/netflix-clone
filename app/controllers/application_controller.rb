class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def require_user
    redirect_to root_path and store_location unless current_user
  end

  def require_admin
     require_user || (redirect_to root_path unless current_user.admin?)
  end

  def store_location
    session[:return_to] = request.referer || request.fullpath
  end

  def redirect_back
    redirect_to (session.delete(:return_to) || root_path)
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
end
