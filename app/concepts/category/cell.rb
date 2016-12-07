class Category::Cell < Cell::Concept
  class Link < Cell::Concept
    include Cell::ListCell
    inherit_views Category::Cell

    property :child_categories
    property :name

    self.classes = %w(category-links)

    def show
      render :link
    end

    private

    # TODO: Change to route
    def url(link)
      '#'
    end

  end
end