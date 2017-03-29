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
        post = context[:operation].contract.post
        unless post.nil? || post.published_on.nil?
          post.published and post.published_on < Date.today
        else
          false
        end
      end
    end
  end
end