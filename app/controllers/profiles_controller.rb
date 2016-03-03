# require_dependency 'profile/operations'

class ProfilesController < ApplicationController
  def edit
    @user = User.find(params[:user_id])
  end
end
