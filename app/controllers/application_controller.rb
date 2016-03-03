class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_mailer_host

  rescue_from Trailblazer::NotAuthorizedError, with: :user_not_authorized
  helper_method :tyrant

  include Trailblazer::Operation::Controller
  # require 'trailblazer/operation/controller/active_record'
  # include Trailblazer::Operation::Controller::ActiveRecord # named instance variables.

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end

  private

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  # Always push current_user in the params for handling policy in operations
  def process_params!(params)
    params.merge!(current_user: tyrant.current_user.id) if tyrant.signed_in?
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.gsub('::', '.').downcase

    flash[:error] = _("#{policy_name}.#{exception.query}") % {scope: 'authorization', default: :default}
    redirect_to(request.referrer || root_path)
  end
end
