require 'test_helper'

class SessionConceptTest < Cell::TestCase
  test "show" do
    html = concept("session/cell").(:show)
    assert html.match /<p>/
  end


end
