module Profile::Contact
    module Cell
      class Show < Trailblazer::Cell
        include ::Cell::LabelValueCell

        property :profile
        property :network_accounts

        self.base_class = 'profile-user-details'

        private

        def profile_fields
          %w(first_name last_name gender date_of_birth birth_place home country)
        end

        def user_fields
          %w(email)
        end

      end
    end
  end
