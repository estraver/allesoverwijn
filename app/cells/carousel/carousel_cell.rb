module Carousel
  class CarouselCell < Cell::ViewModel
    include Cell::CarouselCell

    def carousel_slides
      model.slides
    end

  end
end