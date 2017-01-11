module Profile::NetworkAccount
  module Cell
    class Fields < Trailblazer::Cell
      include ActionView::RecordIdentifier
      include ActionView::Helpers::FormOptionsHelper
      include SimpleForm::ActionViewExtensions::FormHelper

      property :id
      property :account_type
      property :account

      private

      def account_type_options
        NetworkAccount.account_types.keys.map do | account_type |
          [account_type, account_type, data: { icon: "fa fa-#{account_type} fa-fw"}]
        end
      end

    end
  end
end

