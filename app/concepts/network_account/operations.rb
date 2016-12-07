class NetworkAccount < ActiveRecord::Base
  class Update < Trailblazer::Operation
    include Model
    include Trailblazer::Operation::Policy

    model Profile, :find
    policy NetworkAccount::Policy, :owner?

    contract do
      collection :network_accounts,
                 populator: ->(fragment:, **) {
                   network_account = network_accounts.find_by(id: fragment[:id])

                   if network_account && fragment[:account].empty?
                     network_accounts.delete(network_account)
                     return skip!
                   end

                   network_account ? network_account : network_accounts.append(NetworkAccount.new)
                 } do
        property :account
        property :account_type, prepopulator: -> (*) { self.account_type = 0 }

        validation :default do
          required(:account).filled
          required(:account_type).filled(included_in?: NetworkAccount.account_types.keys)
        end
      end
    end

    def process(params)
      validate(params[:profile]) do
        contract.save
      end
    end

    def model!(params)
      Profile.find(params[:profile_id])
    end
  end


end