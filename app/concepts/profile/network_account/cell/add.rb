module Profile::NetworkAccount
  module Cell
    class Add < Trailblazer::Cell
      # include ActionView::RecordIdentifier
      # include ActionView::Helpers::FormOptionsHelper
      # include SimpleForm::ActionViewExtensions::FormHelper

      def show
        cell(Profile::NetworkAccount::Cell::Fields, NetworkAccount.new)
      end

      # private

      # def form
      #   context[:operation].contract
      # end



      # def account_type_options
      #   NetworkAccount.account_types.keys.map do | account_type |
      #     [account_type, account_type, data: { icon: "fa fa-#{account_type} fa-fw"}]
      #   end
      # end

    end
  end
end

