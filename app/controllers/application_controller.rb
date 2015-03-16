class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
	  #验证是否登录，并跳转至登录页面
	  def logged_in_user
	    unless logged_in?
	      store_location 
	      flash[:danger]="Please log in."
	      redirect_to login_url
	    end
	  end
end
