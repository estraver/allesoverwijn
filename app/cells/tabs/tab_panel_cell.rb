module Tabs
  class TabPanelCell < Cell::ViewModel
    property :title
    property :url

    def classes
      :active if active
    end

    def active
      context[:section].eql? model
    end

    def remote
      true
    end
  end
end