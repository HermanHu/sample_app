ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #如果用户已经登录，返回true
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  #登录测试用户
  def log_in_as(user,option={})
    password=option[:password] ||'foobar'
    remember_me=option[:remember_me] || '1'
    
    if integration_test?
      
      post login_path,session:{email: user.email,
                               password: password,
                               remember_me: remember_me}
    else
      session[:user_id]=user.id
    end
  end
  #在集成测试返回true
  private
    def integration_test?
      defined?(post_via_redirect)
    end
end
