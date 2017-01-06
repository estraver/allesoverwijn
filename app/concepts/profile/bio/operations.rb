require_dependency 'profile/operations'
require 'representable/json'

class Profile < ActiveRecord::Base
  module Bio
    class Create < Profile::Create
      include Model, Trailblazer::Operation::Policy

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
          required(:bio).filled
        end
      end

      def process(params)
        validate(params[:profile]) do | contract |
          contract.save
        end
      end

      class JSON < self
        # include Representer
        extend Representer::DSL
        include Representer::Rendering, Responder

        representer do
          property :bio

          property :success, getter: ->(user_options:, **) { user_options[:success] }

        end
      end
    end

    class Show < Create
      action :find
      policy Profile::Policy, :show?
    end
  end

end