require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path,user:{name:" ",
                           email:"invalid@errors",
                           password:"123",
                           password_confirmation:"456"}
    end
    assert_template 'users/new'
   
    
  end
  
 
  test "valid signup information" do
    #get signup_path
    #name="HermanHu1"
    #email="example@gmail.cn"
    #password="foobar"
    #assert_difference 'User.count',1 do
    #  post_via_redirect users_path,user:{name:name,
    #                       email:email,
    #                       password:password,
    #                       password_confirmation:password}
    #end
    #assert_template 'users/show'
    #assert is_logged_in?
  end

  test "valid singup information with account activation" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path,user:{name:"Example User ",
                           email:"user@example.com",
                           password:"password",
                           password_confirmation:"password"}
    end
    assert_equal 1,ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token,email: "wrong")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token,email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
