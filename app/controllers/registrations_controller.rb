require_dependency 'registration/operations'

class RegistrationsController < ApplicationController
  def new
    form Registration::SignUp
  end

  def create
    run Registration::SignUp do |op|
      flash[:notice] = _('registration.created')
      return redirect_to root_path
    end

    render :new
  end
end
