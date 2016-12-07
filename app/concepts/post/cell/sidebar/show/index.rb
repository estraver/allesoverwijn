require 'category/most_used_category_collection'
require 'post/archive/archive_collection'

module Post::Cell
  class Sidebar < Cell::Concept
    include Cell::ListCell

    self.classes = %w(sidebar)

    def show
      render :sidebar
    end

    private

    def categories
      MostUsedCategoryCollection.new(Category, current_user: model.current_user).()
    end

    def archives
      ArchiveCollection.new(Property).()
    end
  end

end