class UsersController < ApplicationController
  respond_to :html
  # before_action only: [:show, :add_network_account_fields] do
  #   redirect_to edit_user_profiles_contact_path(tyrant.current_user) if tyrant.current_user.profile.nil?
  # end

  def show
    op = present User::Show
    redirect_to edit_user_profile_path(current_user, op.model.profile) && return if op.new_profile?
    redirect_to user_profile_path(current_user, op.model.profile)
  end

  def edit
    # op = present User::Show
    redirect_to edit_user_profile_path(current_user, current_user.profile)
  end
end
