require_dependency 'profile/operations'
require_dependency 'representable/json'

class Profile < ActiveRecord::Base
  module Bio
    class Create < Profile::Create
      include Model, Responder, Representer, Trailblazer::Operation::Policy
      include Representer::Deserializer::Hash

      model Profile, :create
      policy Profile::Policy, :create?

      contract do
        property :bio
      end
    end

    class Update < Create
      builds -> (params) do
        JSON if params[:format] =~ 'json'
      end

      action :update

      policy Profile::Policy, :owner?

      contract do
        property :bio

        validation :default do
          # validates :bio, presence: true, allow_blank: false
          key(:bio).required
        end
      end

      def process(params)
        validate(params[:profile]) do |f|
          f.save
        end
      end

      class JSON < self
        representer do
          property :bio
        end
      end
    end
  end

end