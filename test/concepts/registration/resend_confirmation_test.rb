require 'test_helper'

class ResendConfirmationTest < MiniTest::Spec
  describe 'Resend Confirmation' do
    let (:user_confirmed) { users(:user_confirmed) }
    let (:user_not_confirmed) { users(:user_not_confirmed) }
    let (:user_token_expired) { users(:user_token_expired) }

    it 'cannot resend if already confirmed' do
      res, op = Registration::ResendConfirmationToken.run(id: user_confirmed.id)

      res.must_equal false
      op.contract.errors[:'auth_meta_data.confirmed_at'].must_include 'cannot be defined'
    end

    it 'cannot resend if token is still valid' do
      res, op = Registration::ResendConfirmationToken.run(id: user_not_confirmed.id)

      res.must_equal false
      op.contract.errors[:'auth_meta_data.confirmation_sent_at'].first.must_match "must be less than #{2.weeks.ago.to_date}"
    end

    it 'can resend if token is 2 weeks old and not already confirmed' do
      res, op = Registration::ResendConfirmationToken.run(id: user_token_expired.id)

      res.must_equal true
      op.model.reload
      op.model.auth_meta_data.confirmation_sent_at.to_date.must_equal Date.today
    end
  end
end

