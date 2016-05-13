class ProfilesController < ApplicationController
  before_action do
    @user = User.find(params[:user_id])
    @profile = Profile.find(params[:profile_id] || params[:id])
  end

  def edit
    redirect_to edit_user_profile_contact_path(@user, @profile)
  end

  def show
    redirect_to user_profile_contact_path(@user, @profile)
  end

  private

  def process_params!(params)
    super
    params.merge!(id: params[:profile_id])
  end

end
