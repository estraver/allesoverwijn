require 'test_helper'

class ProfileBioTest < MiniTest::Spec
  describe 'Profile Bio' do
    let (:user) { users(:user_with_empty_profile) }
    it 'do not update if bio is empty' do
      res, op = Profile::Bio::Update.run(id: user.profile.id, current_user: user.id, profile: { user_id: user.id, bio: '' })

      res.must_equal false
      op.contract.errors[:bio].must_include 'must be filled'
    end

    it 'updates when bio is given' do
      res, op = Profile::Bio::Update.run(id: user.profile.id, current_user: user.id,  profile: { user_id: user.id, bio: 'Bio' } )

      res.must_equal true
      op.model.bio.must_equal 'Bio'
    end
  end
end