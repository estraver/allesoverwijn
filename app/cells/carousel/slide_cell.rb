module Carousel
  class SlideCell < Cell::ViewModel
    include Cell::CarouselCell

    def show
      slide(model)
    end
  end
end