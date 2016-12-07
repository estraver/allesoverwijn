class User < ActiveRecord::Base
  # serialize :auth_meta_data
  has_one :auth_meta_data, dependent: :destroy, autosave: true
  has_one :profile, dependent: :destroy
  has_many :posts, through: :post_contents

  has_and_belongs_to_many :roles
end