class StaticPagesController < ApplicationController
  def home
  	@micropost=current_user.microposts.build if logged_in?
  	
  	@feed_items = current_user.feed.paginate(page:params[:page]) if logged_in?
  end
  
  def about
  end
  
  def help
  end
end
