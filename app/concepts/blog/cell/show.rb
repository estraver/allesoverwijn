module Blog::Cell
  class Show < Trailblazer::Cell
    include Cell::ContentCell

    def preview?
      options[:preview] || false
    end

  end
end