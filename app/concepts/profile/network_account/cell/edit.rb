module Profile::NetworkAccount
  module Cell
    class Edit < Trailblazer::Cell
      include ActionView::RecordIdentifier
      # include ActionView::Helpers::FormOptionsHelper
      include SimpleForm::ActionViewExtensions::FormHelper

      property :user
      property :network_accounts

      private

      def form
        context[:operation].contract
      end

      # def account_type_options
      #   NetworkAccount.account_types.keys.map do | account_type |
      #     [account_type, account_type, data: { icon: "fa fa-#{account_type} fa-fw"}]
      #   end
      # end

      def url
        user_profile_network_accounts_path(model.user, model)
      end
    end
  end
end

