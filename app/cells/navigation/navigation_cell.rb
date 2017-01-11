# TODO: Rename tot Navbar
module Navigation
  class NavigationCell < Cell::ViewModel
    include Cell::NavigationCell
    include Layout::External

    private

    def navigation_links
      model.all
    end

  end
end
