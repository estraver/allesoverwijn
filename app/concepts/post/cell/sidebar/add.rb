module Post::Cell
  module Sidebar
    class Add < Trailblazer::Cell
      include ActionView::Helpers::FormOptionsHelper
      include SimpleForm::ActionViewExtensions::FormHelper

      def title
        _('post.sidebar.add')
      end

      def add_path
        # url_for context[:operation].model.class
        url_for action: 'new'
      end

    end
  end
end

