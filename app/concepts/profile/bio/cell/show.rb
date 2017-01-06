module Profile::Bio
  module Cell
    class Show < Trailblazer::Cell
      include ::Cell::LabelValueCell

    property :profile

    self.base_class = 'profile-user-details'

    private

    def bio_fields
      %w(bio)
    end

    end
  end
end