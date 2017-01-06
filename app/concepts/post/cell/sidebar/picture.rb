module Post::Cell
  module Sidebar
    class Picture < Trailblazer::Cell
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
