class User < ActiveRecord::Base
  class SignIn < Trailblazer::Operation
    include Model
    model User, :update

    contract do
      property :sign_in_count
      property :current_sign_in_at
      property :last_sign_in_at
    end

    def process(user)
      assign_user! user
      sign_in!
      contract.save
    end

    private

    def sign_in!
      contract.sign_in_count += 1
      contract.last_sign_in_at = contract.current_sign_in_at
      contract.current_sign_in_at = DateTime.now
    end

    def assign_user!(user)
      contract.sign_in_count = user.sign_in_count
      contract.last_sign_in_at = user.last_sign_in_at
      contract.current_sign_in_at  = user.current_sign_in_at
    end
  end
end