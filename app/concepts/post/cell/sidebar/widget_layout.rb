module Post::Cell
  module Sidebar
    class WidgetLayout < Trailblazer::Cell
      include Cell::ListCell

      self.classes = %w(sidebar)

      def title
        model[model.keys.first][:title]
      end
    end
  end
end