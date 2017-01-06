module Blog::Cell
  class Meta < Trailblazer::Cell
    include Cell::ContentCell

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