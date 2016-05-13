class NetworkAccount < ActiveRecord::Base
  class Update < Trailblazer::Operation
    include Model
    include Trailblazer::Operation::Policy

    model Profile, :find
    policy NetworkAccount::Policy, :owner?

    contract do
      collection :network_accounts,
                 populator: ->(fragment:, **) {
                   network_account = network_accounts.find_by(id: fragment['id'])

                   if fragment['account'].empty?
                     network_accounts.delete(network_account)
                     return skip!
                   end

                   network_account ? network_account : network_accounts.append(NetworkAccount.new)
                 } do
        property :account
        property :account_type, prepopulator: -> (*) { self.account_type = 0 }

        validates :account, presence: true, allow_blank: false
        validates :account_type, presence: true, allow_blank: false
        validates :account_type, inclusion: {in: NetworkAccount.account_types.keys }
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