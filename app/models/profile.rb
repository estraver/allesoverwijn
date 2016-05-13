class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :address_profiles, dependent: :destroy
  has_many :addresses, through: :address_profiles
  has_many :network_accounts, dependent: :destroy

  enum gender: [:male, :female]

  serialize :photo_meta_data

end
