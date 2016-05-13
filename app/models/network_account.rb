class NetworkAccount < ActiveRecord::Base
  belongs_to :profile

  enum account_type: [:facebook, :twitter, :linkedin, :skype]
end
