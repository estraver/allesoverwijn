module Post::Cell
  module Sidebar
    class Picture < Trailblazer::Cell
      include SimpleForm::ActionViewExtensions::FormHelper

      layout :widget_edit_layout

      def title
        _('post.sidebar.picture.menu')
      end

      def icon
        'fa-file-picture-o'
      end
    end
  end
end
