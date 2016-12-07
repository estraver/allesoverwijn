class Profile::Cell < Cell::Concept
  class Bio::Cell <  Cell::Concept
    property :profile

    include Cell::LabelValueCell

    self.base_class = 'profile-user-details'

    def show
      render
    end

    private

    def bio_fields
      %w(bio)
    end

  end
end
