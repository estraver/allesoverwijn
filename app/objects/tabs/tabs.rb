module Tabs
  class Tabs
    attr_reader :panels, :name

    def self.setup!(config = 'config/tabs.yml')
      config = YAML.load_file(config)

      Rails.cache.fetch('objects/tabs', force: true) do
        self.build_tabs(config[:tabs])
      end
    end

    def self.[](id)
      self.find(id)
    end

    def initialize(name, panels)
      @name = name
      @panels = panels.map do | panel |
        Tabs::Panel.new(panel)
      end
    end

    private

    def self.build_tabs(config)
      config.keys.map do | tab |
        {id: tab, tab: Tabs.new(tab, config[tab])}
      end
    end

    def self.find(id)
      Rails.cache.fetch('objects/tabs').detect do |tab|
        tab[:id].eql? id
      end[:tab]
    end

    class Panel
      include ActionView::Helpers
      include ActionDispatch::Routing
      include Rails.application.routes.url_helpers

      attr_reader  :title, :url, :panel, :name

      def initialize(panel)
        @title = panel[:title]
        @url = panel[:url]
        @panel = panel[:panel]
        @name = panel[:name]
      end

      def title
        _(@title)
      end

      def panel
        @panel.classify
      end

      def url(options = {})
        polymorphic_url @url, options.merge(only_path: true)
      end

    end

  end
end
