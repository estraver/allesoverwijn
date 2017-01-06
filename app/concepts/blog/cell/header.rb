module Blog::Cell
  class Header < Trailblazer::Cell
    include Cell::ContentCell

    def preview?
      context[:preview]
    end
  end
end