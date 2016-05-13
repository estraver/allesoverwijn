require_dependency 'network_account/operations'

class NetworkAccountsController < ApplicationController
  respond_to :html, :json, :js

  def new
    form NetworkAccount::Update
    render :add_network_account_fields
  end

  def create
    respond NetworkAccount::Update do | op, format |
      format.json {
        render_json op, 'network_account.create'
      }
      format.js { render :add_network_account_fields }
    end
  end

  def add_network_account_fields
    form NetworkAccount::Update
  end

  def update
    respond NetworkAccount::Update do | op, format |
      format.json {
        render_json op, 'network_account.update'
      }
      format.js { render :refresh_network_account_fields }
    end
  end

  def show
    present NetworkAccount::Update
  end

end
