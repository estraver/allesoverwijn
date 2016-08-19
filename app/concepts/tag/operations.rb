class Tag < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model, Policy

    model Tag, :create



  end
end