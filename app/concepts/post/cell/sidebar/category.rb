module Post::Cell
  module Sidebar
    class Category < Trailblazer::Cell
      include ::Cell::Builder

      builds do |model, options|
        if options[:context][:operation].class.to_s.demodulize.eql? 'Update'
          Edit
        else options[:context][:operation].class.to_s.demodulize.eql? 'Show'
          Show
        end
      end

      class Edit < self
        include SimpleForm::ActionViewExtensions::FormHelper
        # include Cell::Haml

        layout :widget_edit_layout

        def title
          _('post.sidebar.category')
        end

        def icon
          'fa-list-ul'
        end

        def operation
          context[:operation]
        end
      end

      class Show < self
        include Cell::ListCell

        layout :widget_show_layout

        private

        self.classes = %w(category-link)

        def title
          _('posts.sidebar.categories')
        end

        def categories
          MostUsedCategoryCollection.new(::Category, current_user: context[:current_user]).()
        end

        # TOOD: let's route ta a real url
        def url(link)
          '#'
        end
      end
    end
  end
end