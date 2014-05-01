class Pantry < ActiveRecord::Base
	before_save { self.name = name.downcase }
	belongs_to :user

	validates :name, presence: true#, uniqueness: true
	validates :user_id, presence: true

	#scope :singularorplural, lambda { where(:name => @ingredient.name.singularize) | where(:name => @ingredient.name.pluarlize)}
end
