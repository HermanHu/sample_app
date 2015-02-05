class User < ActiveRecord::Base
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
end
