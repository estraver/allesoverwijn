module Post::Cell
  module Sidebar
    module Edit
      class Index < Trailblazer::Cell
        def title
          context[:title]
        end

        def params(widget)
          context[widget.to_sym]
        end

        def widgets
          context[:widgets]
        end

        def form
          context[:form]
        end
      end
    end
  end
end