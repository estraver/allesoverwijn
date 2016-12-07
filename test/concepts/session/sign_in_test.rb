require 'test_helper'

class SignInTest < MiniTest::Spec
  describe 'Sign In' do
    let (:admin) { users(:admin) }

    it 'fails with wrong password' do
      res, op = Session::SignIn.run(user: {email: 'e.straver@xs4all.nl', password: 'xxx'})

      res.must_equal false
      op.contract.errors[:password].must_include 'Session.sign_in.password.not.ok'
    end

    it 'fails with no email and password' do
      res, op = Session::SignIn.run(user: {email: '', password: ''})

      res.must_equal false
      op.contract.errors[:email].must_include 'must be filled'
      op.contract.errors[:password].must_include 'must be filled'
    end

    it 'fails with no valid email address' do
      res, op = Session::SignIn.run(user: {email: 'e.straver@xs4all.nl', password: '123123'})

      res.must_equal false
      op.contract.errors[:email].must_include 'Session.sign_in.no.valid.email'
    end

    it 'success with correct username and password' do
      sign_in_count = admin.sign_in_count
      res, op = Session::SignIn.run(user: {email: 'admin@allesoverwijn.nl', password: '654321a!'})

      res.must_equal true
      op.model.reload
      op.model.sign_in_count.must_equal sign_in_count+1
    end

  end

end