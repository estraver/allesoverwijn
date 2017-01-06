module Post::Cell
  module Layout
    class Index < Trailblazer::Cell
      include Cell::PagerCell

      def widgets
        context[:widgets]
      end

      # def cell_name(widget)
      #   "post/cell/sidebar/#{widget.keys.first.to_s.singularize}"
      # end

    end
  end
end