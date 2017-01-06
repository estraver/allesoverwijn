require 'user_util/guest'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  before_filter :set_mailer_host

  rescue_from Trailblazer::NotAuthorizedError, with: :user_not_authorized
  helper_method :current_user

  include Trailblazer::Operation::Controller

  def current_user
    @current_user ||= tyrant.current_user || UserUtil::Guest
  end

  private

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  # Always push current_user in the params for handling policy in operations
  def process_params!(params)
    params.merge!(current_user: current_user)
    params.merge!(format: request.format)
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.gsub('::', '.').downcase

    flash[:error] = _("#{policy_name}.#{exception.query}") % {scope: 'authorization', default: :default}
    respond_to do | format |
      format.html { redirect_to(request.referrer || root_path) }
      format.js { render :flash }
      format.json { render json: flash }
    end

  end

  def render_json(operation, message)
    if operation.errors.empty?
      render json: operation.to_json(user_options: { success: _("#{message}.success"), current_user: current_user })
    else
      render json: { errors: operation.contract.errors.messages, error: _("#{message}.failed") }, status: :unprocessable_entity
    end

  end

  def json_request?
    request.format.json?
  end

  # FIXME: Reconsider when context and collection bug is repaired
  def _cell(name, model=nil, options={}, constant=::Cell::ViewModel, &block)
    options[:context] ||= {}
    options[:context][:controller] = self

    options[:context].merge! model[:context] if model.is_a?(Hash) and model.has_key?(:context)

    constant.cell(name, model, options, &block)
  end


end
