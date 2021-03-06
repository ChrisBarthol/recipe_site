class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :recipe
	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :recipe_id, presence: true
	validates :content, presence: true, length: { maximum: 500 }

	def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  	end

  	def commentfeed
		Comment.where("recipe_id = ?", id)
	end
end
