class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :address_profiles, dependent: :destroy
  has_many :addresses, through: :address_profiles

  enum gender: [:male, :female]
end
