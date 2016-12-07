require 'test_helper'

class ProfileContactTest < MiniTest::Spec
  describe 'Profile Contact' do
    let (:user) { users(:user_with_empty_profile) }

    it 'do not update if first name is empty' do
      res, op = Profile::Contact::Update.run(id: user.profile.id, current_user: user.id, profile: {first_name: '', last_name: '', date_of_birth: '1974-03-21'})

      res.must_equal false
      op.contract.errors[:first_name].must_include 'must be filled'
    end

    it 'do not update if last name is empty' do
      res, op = Profile::Contact::Update.run(id: user.profile.id, current_user: user.id, profile: {first_name: '', last_name: '', date_of_birth: '1974-03-21'})

      res.must_equal false
      op.contract.errors[:last_name].must_include 'must be filled'
    end

    it 'do not update if date of birth is wrong' do
      res, op = Profile::Contact::Update.run(id: user.profile.id, current_user: user.id, profile: {first_name: 'Erwin', last_name: 'Straver', date_of_birth: '1974-21-03'})

      res.must_equal false
      op.contract.errors[:date_of_birth].must_include 'Profile.date_of_birth.not_a_date'

    end

    it 'updates' do
      res, op = Profile::Contact::Update.run(id: user.profile.id, current_user: user.id, profile: {first_name: 'Erwin', last_name: 'Straver', date_of_birth: '1974-03-21'})

      res.must_equal true
      op.contract.model.first_name.must_equal 'Erwin'

    end

  end
end