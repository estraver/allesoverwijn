class Role < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    # include Policy

    # policy Policy::Role, :create?
    model Role, :create

  end

  class Update < Create

  end

end