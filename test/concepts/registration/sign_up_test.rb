require 'test_helper'

class SignUpTest < MiniTest::Spec
  describe 'Registration' do
    let (:admin) { users(:admin) }
    it 'is successfull' do
      res, op = Registration::SignUp.run(user: {name: 'Erwin', email: 'e.straver@xs4all.nl', password: 'Fr@nc!s2016', password_confirmation: 'Fr@nc!s2016'})

      op.model.persisted?.must_equal true
      op.model.email.must_equal 'e.straver@xs4all.nl'
      op.model.reload
      op.model.auth_meta_data.confirmation_sent_at.wont_be_nil

      Registration::Authenticatable.new(op.model).digest?('Fr@nc!s2016').must_equal true
    end

    it 'not successfull when password and confirmation are not equal' do
      res, op = Registration::SignUp.run(user: {name: 'Erwin', email: 'e.straver@xs4all.nl', password: 'Fr@nc!s2016', password_confirmation: 'Franc!s2016'})

      op.model.persisted?.must_equal false
      op.contract.errors[:password_confirmation].must_include 'must be equal to Fr@nc!s2016'
    end

    it 'not successfull when password is too short ' do
      res, op = Registration::SignUp.run(user: {name: 'Erwin', email: 'e.straver@xs4all.nl', password: 'Fr@nc!s', password_confirmation: 'Franc!s'})

      op.model.persisted?.must_equal false
      op.contract.errors[:password].must_include 'size cannot be less than 8'
    end

    it 'not successfull when password is too weak ' do
      res, op = Registration::SignUp.run(user: {name: 'Erwin', email: 'e.straver@xs4all.nl', password: 'francis', password_confirmation: 'francis'})

      op.model.persisted?.must_equal false
      op.contract.errors[:password].must_include 'Registration.sign_up.password.weak'
    end

    it 'not successfull when name or email is not filled' do
      res, op = Registration::SignUp.run(user: {name: '', email: '', password: 'francis', password_confirmation: 'francis'})

      op.model.persisted?.must_equal false
      op.contract.errors[:email].must_include 'must be filled'
      op.contract.errors[:name].must_include 'must be filled'
    end

    it 'not successfull when name or e-mail already exists' do
      res, op = Registration::SignUp.run(user: {name: admin.name, email: admin.email, password: 'francis2016', password_confirmation: 'francis2016'})

      op.model.persisted?.must_equal false
      op.contract.errors[:email].must_include 'Registration.sign_up.email.not.unique'
      op.contract.errors[:name].must_include [admin.name, ['Registration.sign_up.name.not.unique']]
    end
  end


end