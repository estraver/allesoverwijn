class Profile < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    include Trailblazer::Operation::Policy

    model Profile, :create
    policy Profile::Policy, :create?

    def process(params)
      model.save(params[:profile])
    end
  end

  class Update < Create
    action :update
  end
end