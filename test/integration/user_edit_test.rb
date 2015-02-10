require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user=users(:Herman)
  end
  
 
  test "unseccessful edit" do
    log_in_as(@user,remember_me:'0')
    get edit_user_path(@user)
    patch user_path(@user),user:{name: "",
                                 email: "for@niv",
                                 password:"foor",
                                 password_confirmation:"bar"}
    
    assert_template 'users/edit'     
  end
  
  test "successful edit" do
    log_in_as(@user,remember_me:'0')
    get edit_user_path(@user)
    name="Micky"
    email="micky@gmail.com"
    patch user_path(@user),user:{name: name,
                                 email: email,
                                 password: "",
                                 password_confirmation: ""}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name,name
    assert_equal @user.email,email
  end
  
  test "successful edit with friendly fowarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
  end
  
end
