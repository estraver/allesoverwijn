require 'test_helper'

class CarouselConceptTest < Cell::TestCase
  test "show" do
    html = concept("carousel_slide/cell").(:show)
    assert html.match /<p>/
  end


end
