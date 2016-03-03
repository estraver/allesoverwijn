require 'test_helper'

class NavigationLinkConceptTest < Cell::TestCase
  test "show" do
    html = concept("navigation_link/cell").(:show)
    assert html.match /<p>/
  end


end
