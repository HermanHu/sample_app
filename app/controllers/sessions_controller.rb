class SessionsController < ApplicationController
  def new
  end
  
  def create
    
    user=User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      
      redirect_to user
    else
      flash.now[:danger]="Invalid email/password combination."
      render 'new' #render方法指向views, rails称之为template
    end
  end  
  
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

end
