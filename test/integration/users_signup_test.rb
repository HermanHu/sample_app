require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    get signup_path
    name="HermanHu1"
    email="example@gmail.cn"
    password="foobar"
    assert_difference 'User.count',1 do
      post_via_redirect users_path,user:{name:name,
                           email:email,
                           password:password,
                           password_confirmation:password}
    end
    assert_template 'users/show'
  end
end
