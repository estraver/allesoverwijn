require 'test_helper'
require 'attachment/profile_attachment'

class ProfilePhotoTest < MiniTest::Spec
  describe 'Photo' do
    let (:user) { users(:user_with_empty_profile)}

    it 'will not upload when it is not the right format' do
      res, op = Profile::Photo::Update.run(id: user.profile.id, current_user: user.id, photo: {file: File.open('test/files/eticket.pdf')})

      res.must_equal false
      op.contract.errors[:file].must_include 'File.wrong.type'
    end

    it 'will not upload when it is bigger then 1MB' do
      res, op = Profile::Photo::Update.run(id: user.profile.id, current_user: user.id, photo: {file: File.open('test/files/dali.jpg')})

      res.must_equal false
      op.contract.errors[:file].must_include 'File.wrong.size'

    end

    it 'will upload' do
      res, op = Profile::Photo::Update.run(id: user.profile.id, current_user: user.id, photo: {file: File.open('test/files/dali.png')})

      res.must_equal true
      ProfileAttachment.new(op.model.photo_meta_data).exists?.must_equal true

    end
  end
end