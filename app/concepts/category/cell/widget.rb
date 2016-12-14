module Category::Cell
  class Widget < Trailblazer::Cell
    # layout Post::Cell::Sidebar::Index

    include Cell::ListCell



    self.classes = %w(category-link)

    def title
      _('posts.sidebar.categories')
    end

    def show
      categories.map { |category| list_item category, url(category), category.name }.join
    end

    private

    def categories
      MostUsedCategoryCollection.new(Category, current_user: context[:current_user]).()
    end

    def url(link)
      '#'
    end
  end
end