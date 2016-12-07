module Post::Cell
  module Sidebar
    class Picture < Trailblazer::Cell
      def title
        context[:title]
      end
    end
  end
end
