class UsersController < ApplicationController
  before_action only: [:show, :edit] do
    redirect_to new_user_profile_path(tyrant.current_user) if tyrant.current_user.profile.nil?
  end

end
