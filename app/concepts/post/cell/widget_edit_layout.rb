module Post::Cell
  module Sidebar
    class WidgetEditLayout < Trailblazer::Cell

      def title
        model[model.keys.first][:title]
      end
    end
  end
end