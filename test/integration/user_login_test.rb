require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "should get flash danger on other page" do
    get login_path
    assert_template "sessions/new"
    post login_path,session:{email: "",password: ""}
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert_template "static_pages/home"
    assert flash.empty?
  end
end
