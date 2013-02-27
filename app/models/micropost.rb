class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  default_scope order: 'microposts.created_at DESC'

  validates_presence_of(:user_id)
  validates_presence_of(:content)
  validates_length_of(:content,:maximum => 140)
end
