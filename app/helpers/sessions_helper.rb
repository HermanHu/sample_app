module SessionsHelper
  def log_in(user)
    session[:user_id]=user.id
  end
  
  def log_out
    forget(current_user) 
    session.delete(:user_id)
    @current_user = nil
  end
  
  #返回cookie中的用户
  def current_user
    if(user_id=session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif(user_id=cookies.signed[:user_id])
     
      user= User.find_by(id: user_id)
      
      if user && user.authenticated?(:remember,cookies[:remember_token])
        log_in user 
        @current_user = user
      end
    end
  end
  
  #忘记用户，删除cookies
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    
  end
  def logged_in?
    !current_user.nil?
  end
  
  #在持久会话中记住用户
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id]=user.id
    cookies.permanent[:remember_token]=user.remember_token
    
  end
  
  #如果指定用户是当前用户，返回true
  def current_user?(user)
    user==current_user
  end
  
  #重定向到存储的地址或默认地址
  def redirect_back_or(default)
    redirect_to(session[:foward_url]||default)
    session.delete(:foward_url)
  end
  
  #存储重定向将要去的地址
  def store_location
    session[:foward_url]=request.url if request.get?
  end
end
