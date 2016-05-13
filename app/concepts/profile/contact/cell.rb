class Profile::Cell < Cell::Concept
  class Contact::Cell <  Cell::Concept
    property :profile

    include Cell::LabelValueCell

    self.base_class = 'profile-user-details'

    def show
      render
    end

    private

    def profile_fields
      %w(first_name last_name)
    end

    def user_fields
      %w(email)
    end
  end
end
