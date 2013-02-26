class User < ActiveRecord::Base
  attr_accessible :email, :name, :password ,:password_confirmation

  #Validatation of Name
  validates_presence_of(:name)
  validates_length_of(:name,:maximum => 50)

  #Validatation of Email
  validates_presence_of(:email)
  validates_length_of(:email,:maximum => 100)
  validates_format_of(:email,:with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  validates_uniqueness_of(:email,case_sensitive: false)
  before_save{|user| user.email=email.downcase}

  #Validation of Password
  validates_presence_of(:password)
  validates_length_of(:password,:minimum => 6)
  has_secure_password

  #Validation of Password Confirmation
  validates_presence_of(:password_confirmation)

  #Validation of Remember Token
  before_save :create_remember_token


  private
  def create_remember_token
    self.remember_token=SecureRandom.urlsafe_base64
  end
end
