require 'test_helper'

class RegistrationConceptTest < Cell::TestCase
  test "show" do
    html = concept("registration/cell").(:show)
    assert html.match /<p>/
  end


end
