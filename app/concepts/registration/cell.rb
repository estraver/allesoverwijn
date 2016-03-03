class Registration::Cell < Cell::Concept
  def show
    render
  end

  class Form < Cell::Concept
    include SimpleFormForCell

  end
end
