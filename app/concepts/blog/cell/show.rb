module Blog::Cell
  class Show < Trailblazer::Cell
    include Cell::ContentCell

    def preview?
      context[:preview] || false
    end

  end
end