# require_dependency 'network_account/operations'

module Profiles
  class NetworkAccountsController < ProfilesController
    respond_to :html, :json

    def new
      form NetworkAccount::Update
      render html: cell(Profile::NetworkAccount::Cell::Add, @model, context: {current_user: current_user, operation: @operation})
    end

    def create
      respond NetworkAccount::Update do | op, format |
        format.json {
          render_json op, 'network_account.create'
        }
        format.html { render html: cell(Profile::NetworkAccount::Cell::Edit, @model, context: {current_user: current_user, operation: @operation}) }
      end
    end

    def update
      respond NetworkAccount::Update do | op, format |
        format.json {
          render_json op, 'network_account.update'
        }
        format.html { render html: cell(Profile::NetworkAccount::Cell::Edit, @model, context: {current_user: current_user, operation: @operation}) }
      end
    end

    def show
      present NetworkAccount::Update
    end

  end
end

