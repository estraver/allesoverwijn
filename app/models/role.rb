class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  serialize :role_meta_data
end