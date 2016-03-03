require_dependency 'session/operations'

class SessionsController < ApplicationController
  before_action only: [:new, :create] do
    redirect_to tyrant.current_user if tyrant.signed_in?
  end

  def new
    form Session::SignIn
  end

  def create
    run Session::SignIn do |op|
      tyrant.sign_in!(op.model)
      return redirect_to op.model
    end

    render :new
  end

  def destroy
    run Session::SignOut do |op|
      tyrant.sign_out!
      redirect_to root_path
    end

  end
end
