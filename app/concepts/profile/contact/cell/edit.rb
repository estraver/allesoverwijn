module Profile::Contact
  module Cell
    class Edit < Trailblazer::Cell
      include ActionView::RecordIdentifier
      include SimpleForm::ActionViewExtensions::FormHelper

      property :user
      property :network_accounts

      private

      def form
        context[:operation].contract
      end

      def url
        user_profile_contact_path(model.user, model)
      end

    end
  end
end

