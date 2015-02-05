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
    follow_redirect!
    assert_template "static_pages/home"
    assert_select "a[href=?",login_path,count:2
    
  end
end
