class NavigationLink
  # FIXME: Like to use url routes, but it sucks to include the right modules

  attr_reader :name, :links, :url, :url_options, :icon
  # cattr_accessor :navigation_links

  def self.setup!(navigation_config = 'config/navigation.yml')

      config = YAML.load_file(navigation_config)
      Rails.cache.fetch('objects/navigation_links', force: true) do
        self.build_links(config[:navigation])
      end
  end

  def self.all
    Rails.cache.fetch('objects/navigation_links')
  end

  def self.build_links(navigation)
    navigation_links = []

    navigation.each do | link_sym, link |
      links = []
      links = build_links(link[:links]) if link.has_key?(:links)
      navigation_links << NavigationLink.new(link[:name], link[:url], links, link[:options], link[:icon])
    end

    navigation_links
  end


  def initialize(name, url, links = [], url_options = {}, icon = [])
    @name = name
    @url = url
    # @url = url_for(url.eql?('#') ? url : url.to_sym)
    @links = links
    @icon = icon
    @url_options = url_options
  end

  def humanize
    _(@name)
  end

  def has_links?
    @links && @links.size > 0
  end

  def has_icon?
    @icon && @icon.size > 0
  end

end