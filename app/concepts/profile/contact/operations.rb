require_dependency 'profile/operations'

class Profile < ActiveRecord::Base
  module Contact
    class Create < Profile::Create
      include Model, Responder, Representer, Trailblazer::Operation::Policy
      include Representer::Deserializer::Hash

      model Profile, :create
      policy Profile::Policy, :create?

      contract do
        property :first_name
        property :middle_name
        property :last_name
        property :date_of_birth
        property :home
        property :birth_place
        property :gender
      end

    end

    class Update < Create
      builds -> (params) do
        JSON if params[:format] =~ 'json'
      end

      action :update

      policy Profile::Policy, :owner?

      contract do
        property :first_name
        property :middle_name
        property :last_name
        property :date_of_birth
        property :home
        property :birth_place
        property :gender

        validation :default do
          validates :first_name, presence: true, allow_blank: false
          validates :last_name, presence: true, allow_blank: false
          validate :date_of_birth_ok?
        end

        private

        def date_of_birth_ok?
          return if date_of_birth.blank?

          begin
            errors.add(:date_of_birth, _('profile.contact.no_valid_date_of_birth')) unless Date.parse(date_of_birth).to_s.eql? date_of_birth
          rescue ArgumentError
            errors.add(:date_of_birth, _('profile.contact.no_valid_date_of_birth'))
          end

        end
      end

      def process(params)
        validate(params[:profile]) do
          contract.save
        end
      end

      class JSON < self
        representer do
          property :first_name
          property :middle_name
          property :last_name
          property :date_of_birth
          property :home
          property :birth_place
          property :gender
        end
      end
    end

  end
end