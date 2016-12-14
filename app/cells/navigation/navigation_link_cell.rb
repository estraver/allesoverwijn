module Navigation
  class NavigationLinkCell < Cell::ViewModel
    property :links
    property :name
    property :url
    property :url_options

    include Cell::NavigationCell

    private

    def has_links?
      model.has_links?
    end
  end
end