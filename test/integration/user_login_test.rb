require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    
    @user = users(:Herman)
  end
  
  test "invalid information login" do
    get login_path
    assert_template "sessions/new"
    post login_path,session:{email: "",password: ""}
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert_template "static_pages/home"
    assert flash.empty?
  end
  
  test "valid information login" do
    
    get login_path
    post login_path,session:{email: @user.email,password: "foobar"}
    assert_redirected_to @user
    follow_redirect! # 跟踪至跳转页面 才能渲染视图
    assert_template "users/show"
    assert_select "a[href=?]",login_path,count: 0
    assert_select "a[href=?]",logout_path
    assert_select "a[href=?]",user_path(@user)
  end
  
   test "valid information login followed logout" do
    
    get login_path
    post login_path,session:{email: @user.email,password: "foobar"}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect! # 跟踪至跳转页面 才能渲染视图
    assert_template "users/show"
    assert_select "a[href=?]",login_path,count: 0
    assert_select "a[href=?]",logout_path
    assert_select "a[href=?]",user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    #模拟用户在另一个浏览器登出
    delete logout_path
    follow_redirect!
    assert_template "static_pages/home"
    assert_select "a[href=?]",login_path,count:1
    
  end
  
  test "authenticated? should renturn false if a user with nil digets" do
    assert_not @user.authenticated?(:remember,'')
  end
  
  test "login with rememberme" do
    log_in_as(@user,remember_me:'1')
    assert_not_nil cookies['remember_token']
  end
  
  test "login without rememberme" do
    log_in_as(@user,remember_me:'0')
    assert_nil cookies['remember_token']
  end
end
