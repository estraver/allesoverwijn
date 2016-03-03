class CarouselSlide
  attr_reader :slides, :controls, :name

  def self.setup!(config = 'config/carousel.yml')
    config = YAML.load_file(config)

    Rails.cache.fetch('objects/carousels', force: true) do
      self.build_carousel(config[:carousel])
    end
  end

  def self.[](id)
    self.find(id)
  end

  def initialize(name, slides, controls)
    @name = name
    @slides = slides.map do | slide |
      CarouselSlide::Slide.new(self, slide)
    end
    @controls = controls.map do | control |
      CarouselSlide::Control.new(self, control)
    end
  end

  private

  def self.build_carousel(config)
    config.keys.map do | carousel |
      {id: carousel, carousel: CarouselSlide.new(carousel, config[carousel][:slides], config[carousel][:controls])}
    end
  end

  def self.find(id)
    Rails.cache.fetch('objects/carousels').detect do |carousel|
      carousel[:id].eql? id
    end[:carousel]
  end

  class Slide
    attr_reader  :image, :title, :url, :note, :view, :carousel

    def initialize(carousel, slide)
      @image = slide[:image]
      @title = slide[:title]
      @url = slide[:url]
      @note = slide[:note]
      @view = slide[:view]
      @carousel = carousel
    end

    def humanize
      _(@title)
    end

    def has_view?
      !@view.nil?
    end

    def first?
      @carousel.slides.first.eql? self
    end
  end

  class Control
    attr_reader :position, :slide, :icon, :caption, :carousel

    def initialize(carousel, control)
      @position= control[:position]
      @slide= control[:slide]
      @icon= control[:icon]
      @caption= control[:caption]
      @carousel = carousel
    end

    def humanize
      _(@caption)
    end

  end

end