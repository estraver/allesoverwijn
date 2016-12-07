require 'test_helper'

class AcceptTest < MiniTest::Spec
  describe 'Confirmation' do
    let (:user_confirmed) { users(:user_confirmed) }
    let (:user_not_confirmed) { users(:user_not_confirmed) }
    let (:user_token_expired) { users(:user_token_expired) }

    it 'is accepted with right token' do
      token = user_not_confirmed.auth_meta_data.confirmation_token
      res, op = Confirmation::Accept.run(id: user_not_confirmed.id, confirmation_token: token)

      res.must_equal true
      op.model.persisted?.must_equal true

      Registration::Authenticatable.new(op.model).confirmed?.must_equal true
    end

    it 'is not accepted with wrong token' do
      token = SecureRandom.urlsafe_base64
      res, op = Confirmation::Accept.run(id: user_not_confirmed.id, confirmation_token: token)

      res.must_equal false
      op.contract.errors[:confirmation_token].must_include 'Registration.confirmation.token.invalid'

    end

    it 'is already confirmed' do
      token = user_confirmed.auth_meta_data.confirmation_token
      res, op = Confirmation::Accept.run(id: user_confirmed.id, confirmation_token: token)

      res.must_equal false
      op.contract.errors[:confirmation_token].must_include 'Registration.confirmation.token.invalid'

    end

    it 'is expired' do
      token = user_token_expired.auth_meta_data.confirmation_token
      res, op = Confirmation::Accept.run(id: user_token_expired.id, confirmation_token: token)

      res.must_equal false
      op.contract.errors[:confirmation_token].must_include 'Registration.confirmation.token.invalid'

    end
  end
end

