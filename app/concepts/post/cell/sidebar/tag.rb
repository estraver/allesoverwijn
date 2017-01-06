module Post::Cell
  module Sidebar
    class Tag < Trailblazer::Cell
      include ActionView::Helpers::FormOptionsHelper
      include SimpleForm::ActionViewExtensions::FormHelper

      layout :widget_edit_layout

      def title
        _('post.sidebar.tags')
      end

      def icon
        'fa-tags'
      end
    end
  end
end

