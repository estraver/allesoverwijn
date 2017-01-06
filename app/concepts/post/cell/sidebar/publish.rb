module Post::Cell
  module Sidebar
    class Publish < Trailblazer::Cell
      include SimpleForm::ActionViewExtensions::FormHelper

      layout :widget_edit_layout

      def title
        _('post.sidebar.published_on')
      end

      def icon
        'fa-calendar'
      end

      def published?
        context[:operation].contract.post.published and context[:operation].contract.post.published_on < Date.today
      end
    end
  end
end