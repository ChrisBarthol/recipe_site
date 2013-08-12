class Recipe < ActiveRecord::Base
	before_save { self.name = name.downcase }

	belongs_to :user
	default_scope -> { order('created_at DESC') }
	has_many :ingredients, dependent: :destroy

	accepts_nested_attributes_for :ingredients, :reject_if => lambda { |a| a[:name].blank? }, :reject_if => lambda { |a| a[:quantity].blank? }, allow_destroy: true
	
	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :description, presence: true
	validates :user_id, presence: true
end	