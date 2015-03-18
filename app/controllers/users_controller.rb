class UsersController < ApplicationController
  
  before_action :logged_in_user,only: [:index,:edit,:update,:destroy,
                                       :following,:followers]
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
    @microposts=@user.microposts.paginate(page: params[:page])
  end
  
  def create
    @user=User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      
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
  
  def following
    @title = "Follwoing"
    @user=User.find(params[:id])
    @users=@user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user=User.find(params[:id])
    @users=@user.followers.paginate(page:params[:page])
    render 'show_follow'
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
