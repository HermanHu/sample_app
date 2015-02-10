class UsersController < ApplicationController
  
  before_action :logged_in_user,only: [:index,:edit,:update,:destroy]
  before_action :correct_user,only:[:edit,:update]
  before_action :admin_user,only:[:destroy]
  
  def new
    @user=User.new
  end
  
  def index
    @users=User.paginate(page: params[:page])
  end
  
  def show

    @user=User.find(params[:id])
  end
  
  def create
    @user=User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to My Website!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user=User.find(params[:id])
  end
  
  def update
    @user=User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Update profile success!"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User deleted"
    redirect_to users_url
  end
  
  #验证是否登录，并跳转至登录页面
  def logged_in_user
    unless logged_in?
      store_location 
      flash[:danger]="Please log in."
      redirect_to login_url
    end
  end
  
  #验证当前登录用户是否编辑用户
  def correct_user
    @user=User.find(params[:id])
    unless current_user?(@user)
      flash[:danger]="You can only edit your profile!"
      redirect_to root_url
    end
  end
  
  #验证当前用户为admin用户
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
    
end
