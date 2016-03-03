require 'test_helper'

class NavigationCellTest < Cell::TestCase
  test "show" do
    html = cell("navigation").(:show)
    assert html.match /<p>/
  end


end
