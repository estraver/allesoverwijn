module Post::Cell
  module Layout
    class Edit < Trailblazer::Cell
      include SimpleForm::ActionViewExtensions::FormHelper
      # include Cell::Haml

      def widgets
        context[:widgets]
      end

      def operation
        context[:operation]
      end

      def title
        context[:title]
      end

      def published?
        operation.contract.post.published
      end

    end
  end
end