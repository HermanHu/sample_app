class User < ActiveRecord::Base
  attr_accessor :remember_token,:activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name,presence: true,length:{maximum:50}
  VALID_EMIAL_REGEX=/\A[\w+\-.]+@[a-z\d\-]+\.?[a-z\d\-]+\.[a-z]+\z/i
  validates :email,presence: true,length:{maximum:250},
            format:{with:VALID_EMIAL_REGEX},
            uniqueness: {case_sensitive: false}
  
  has_secure_password
  validates :password,length:{minimum:6},allow_blank:true
  
  
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
  def authenticated?(attribute,token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  #忘记用户，删除令牌摘要
  def forget
    update_attribute(:remember_digest,nil)
  end
  #Activate account
  def activate
    update_attribute(:activated,true)
    update_attribute(:activated_at,Time.zone.now)
  end
  #send activate email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private
    #把电子邮件地址转为小写
    def downcase_email
      self.email=email.downcase
    end
    #chuangjianbingfuzhijihuolingpaihezhaiyao
    def create_activation_digest
      self.activation_token=User.new_token
      self.activation_digest=User.digest(activation_token)
    end
end
