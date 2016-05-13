class NavigationLink::Cell < Cell::Concept
  property :links
  property :name
  property :url
  property :url_options

  include Cell::NavigationCell

  def show
    render
  end

  def has_links?
    model.has_links?
  end

  class Navigation < Cell::Concept
    include Cell::NavigationCell

    inherit_views NavigationLink::Cell

    def show
      render :navigation
    end

    def navigation_links
      model.all
    end
  end
end
