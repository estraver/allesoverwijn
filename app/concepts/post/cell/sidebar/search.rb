module Post::Cell
  module Sidebar
    class Search < Trailblazer::Cell
      include ActionView::Helpers::FormOptionsHelper
      include SimpleForm::ActionViewExtensions::FormHelper

      layout :widget_show_layout

      def title
        _('post.sidebar.search')
      end

      def search_path
        url_for context[:operation].model.class
      end

      def container(&block)
        form_tag search_path, method: 'post', class: 'form-inline', &block
        # content_tag(:form, class: %w(input-group stylish-input-group), &block)
      end
    end
  end
end

