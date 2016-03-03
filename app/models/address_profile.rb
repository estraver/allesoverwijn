class AddressProfile < ActiveRecord::Base
  belongs_to :address
  belongs_to :profile

  enum address_type: [:postal_address, :home_address, :billing_address, :other_address]
end
