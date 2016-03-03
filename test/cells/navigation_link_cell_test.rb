require 'test_helper'

class NavigationLinkCellTest < Cell::TestCase
  test "show" do
    html = cell("navigation_link").(:show)
    assert html.match /<p>/
  end


end
