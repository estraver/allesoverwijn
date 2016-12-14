module Blog::Cell
  class Index < Trailblazer::Cell
    include Cell::ContentCell

    def preview?
      options[:preview] || false
    end

    # def abstract?
    #   options[:abstract]
    # end

    private

    # TODO: realize comment count
    def comments_count
      0
    end

    # TODO: realize count view
    def views_count
      0
    end
  end
end