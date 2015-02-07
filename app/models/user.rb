class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save {self.email=email.downcase}
  validates :name,presence: true,length:{maximum:50}
  VALID_EMIAL_REGEX=/\A[\w+\-.]+@[a-z\d\-]+\.?[a-z\d\-]+\.[a-z]+\z/i
  validates :email,presence: true,length:{maximum:250},
            format:{with:VALID_EMIAL_REGEX},
            uniqueness: {case_sensitive: false}
  
  has_secure_password
  validates :password,length:{minimum:6}
  
  #用于反悔制定字符串的哈希摘要
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string,cost: cost)                                              
  end
  #反悔一个随机令牌
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  #为了持久会话，存入数据库
  def remember
    self.remember_token=User.new_token
    update_attribute(:remember_digest,User.digest(self.remember_token))
  end
  #验证令牌是否与摘要匹配，返回true or false
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  #忘记用户，删除令牌摘要
  def forget
    update_attribute(:remember_digest,nil)
  end
end
