class Profile < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    include Trailblazer::Operation::Policy

    model Profile, :create
    policy Profile::Policy, :create?

    contract do
      property :first_name, validate: {presence: true}
      property :middle_name
      property :last_name, validate: {presence: true}
      property :date_of_birth
      property :home
      property :birth_place
      property :gender
    end

    def process(params)
      validate(params[:profile]) do
        contract.save
      end
    end
  end
end