module Profile::Bio
  module Cell
    class Edit < Trailblazer::Cell
      include ActionView::RecordIdentifier
      include SimpleForm::ActionViewExtensions::FormHelper

      private

      def form
        context[:operation].contract
      end

      def url
        user_profile_bio_path(model.user, model)
      end

    end
  end
end