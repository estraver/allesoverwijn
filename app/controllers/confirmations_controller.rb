require_dependency 'confirmation/operations'

class ConfirmationsController < ApplicationController
  def show
    run Confirmation::Accept do |op|
      flash[:notice] = _('confirmation.accepted')
      return redirect_to new_session_path
    end

    flash[:error] = _('confirmation.not_accepted')
    redirect_to root_path
  end

  private
  def process_params!(params)
    params.merge!(id: params.delete(:user_id))
    super
  end
end