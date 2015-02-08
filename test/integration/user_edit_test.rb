require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user=users(:Herman)
  end
  
 
  test "unseccessful edit" do
    get edit_user_path(@user)
    patch user_path(@user),user:{name: "",
                                 email: "for@niv",
                                 password:"foor",
                                 password_confirmation:"bar"}
    assert_template 'users/edit'     
  end
  
  test "successful edit" do
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
                                 
end
