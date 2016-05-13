class CarouselSlide::Cell < Cell::Concept
  # property :name

  include Cell::CarouselCell

  def show
    render
  end

  class Carousel < Cell::Concept
    include Cell::CarouselCell

    inherit_views CarouselSlide::Cell

    def show
      render :carousel
    end

    def carousel_slides
      model.slides
    end

  end
end
