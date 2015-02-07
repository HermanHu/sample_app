require 'test_helper'

class SessionsHelperTest<ActionView::TestCase
  def setup
    @user=users(:Herman)
    remember(@user)
  end
 
   
  test "current user renturn nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest,User.digest(User.new_token))
    assert_nil current_user
  end
  
  test "current user return right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
 
end