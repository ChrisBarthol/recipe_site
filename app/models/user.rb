class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	before_create :create_remember_token
	validates :name, presence: true, length: 3..50
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

 	validates :password, length: { minimum: 6 }
 	has_many :recipes
 	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
 	has_many :followed_users, through: :relationships, source: :followed
 	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
 	has_many :followers, through: :reverse_relationships, source: :follower
 	has_many :reciperelationships, foreign_key: "recipesaver_id", dependent: :destroy
 	has_many :saved_recipes, through: :reciperelationships, source: :recipesaved
 	has_many :reverse_reciperelationships, foreign_key: "recipesaved_id", class_name: "Reciperelationship", dependent: :destroy
 	has_many :recipesavers, through: :reverse_reciperelationships, source: :recipesaver
 	has_many :comments, dependent: :destroy
 	before_save { email.downcase! }

 	has_secure_password

 	def feed
 		Comment.from_users_followed_by(self)
 	end
 	
 	def recipesaved?(recipe)
 		reciperelationships.find_by(recipesaved_id: recipe.id)
 	end

 	def recipesave!(recipe)
 		reciperelationships.create!(recipesaved_id: recipe.id)
 	end

 	def recipedelete!(recipe)
 		reciperelationships.find_by(recipesaved_id: recipe.id).destroy
 	end

 	def following?(other_user)
 		relationships.find_by(followed_id: other_user.id)
 	end

 	def follow!(other_user)
 		relationships.create!(followed_id: other_user.id)
 	end

 	def unfollow!(other_user)
 		relationships.find_by(followed_id: other_user.id).destroy!
 	end

 	def User.new_remember_token
 		SecureRandom.urlsafe_base64
 	end

 	def User.encrypt(token)
 		Digest::SHA1.hexdigest(token.to_s)
 	end

 	private

 		def create_remember_token
 			self.remember_token = User.encrypt(User.new_remember_token)
 		end

end
