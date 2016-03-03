class Address < ActiveRecord::Base
  has_many :address_profiles
  has_many :profiles, through: :address_profiles

end
