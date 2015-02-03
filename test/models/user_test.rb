require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup 
    @user=User.new(name:"Herman Hu",email:"example@yahoo.com",
                   password:"foobar",password_confirmation:"foobar")
  end
  
  test "should be valid?" do
    assert @user.valid?  
  end
  
  test "name should be present" do
    @user.name="    "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email="   "
    assert_not @user.valid?
  end
  
  #用户名、email地址最大长度
  test "name should not be too long " do
    @user.name="a"*51
    assert_not @user.valid?
  end
  
  test "email should not be too long " do
    @user.email="a"*251
    assert_not @user.valid?
  end
  
  #测试以下地址能通过email验证
  test "email should accept valid address" do
    valid_addresses=%w[user@example.com USER2@foo.COM 
                    A_pel-tt@foo.bar.org awp.esp@foo-app.jp alid+ddd@foo.cn]
    valid_addresses.each do |valid_addr|
      @user.email=valid_addr
      assert @user.valid?,"#{valid_addr.inspect} shoud be valid"
    end
  end
  #测试一下地址无法通过email地址验证
  test "email should reject invalid address" do
    invalid_address=%w[user@example,com USER2@foo.COM. USER2@foo..COM
                    A_pel-tt&foo.bar.org awp.esp@foo_app.jp alid+ddd@foo+too.cn]
    invalid_address.each do |invalid_addr|
      @user.email=invalid_addr
      assert_not @user.valid?,"#{invalid_addr.inspect} should be invalid"
    end
  end
  
  #测试唯一性
  test "email address should be unique" do
    duplicate_user=@user.dup
    duplicate_user.email=@user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  #测试密码长度
  
  test "password should have minimum length" do
    @user.password=@user.password_confirmation="a"*5
    assert_not @user.valid?
  end
end
