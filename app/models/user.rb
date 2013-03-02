class User < ActiveRecord::Base
  attr_accessible :email, :name, :password ,:password_confirmation
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

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

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    #Micropost.where("user_id = ?",id)
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  private
  def create_remember_token
    self.remember_token=SecureRandom.urlsafe_base64
  end
end
