class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  default_scope order: 'microposts.created_at DESC'

  validates_presence_of(:user_id)
  validates_presence_of(:content)
  validates_length_of(:content,:maximum => 140)

  def self.from_users_followed_by(user)
    followed_user_ids="SELECT followed_id FROM relationships WHERE follower_id= :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id=(:user_id)",user_id: user)
  end
end
