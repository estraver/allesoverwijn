module Post::Cell
  module Sidebar
    class WidgetShowLayout < Trailblazer::Cell
      include Cell::ListCell

      self.classes = %w(sidebar)

      def title
        model[model.keys.first][:title]
      end
    end
  end
end