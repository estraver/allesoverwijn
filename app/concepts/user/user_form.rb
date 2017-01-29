require 'reform/form/coercion'
require 'reform/form/dry'

class UserForm < Reform::Form
  feature Reform::Form::Dry
  feature Coercion

  property :id, type:  Types::Form::Int
  property :email
  property :name
  property :sign_in_count
  property :posts_count
  property :current_sign_in_at

  property :profile do
    property :first_name
    property :last_name
    property :middle_name
    property :bio
    property :gender
    property :date_of_birth
  end

  collection :roles do
    property :name
    property :role_meta_data
  end
end