module Post::Cell
  module Layout
    class Index < Trailblazer::Cell
      def widgets
        context[:widgets]
      end

      def cell_name(widget)
        widget[widget.keys.first].has_key?(:cell) ? widget[widget.keys.first][:cell] : "#{widget.keys.first.to_s.singularize}/cell/widget"
      end

    end
  end
end