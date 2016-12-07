require 'test_helper'

class NetworkAccountUpdateTest < MiniTest::Spec
  describe 'Network account' do
    let (:user) { users(:admin) }

    it 'does not add with empty account and empty account type' do
      res, op = NetworkAccount::Update.run(id: user.id, profile_id: user.profile.id, current_user: user.id, profile: {network_accounts: [{account: '', account_type: ''}]})

      res.must_equal false
      op.contract.errors[:'network_accounts.account'].must_include 'must be filled'
      op.contract.errors[:'network_accounts.account_type'].must_include 'must be filled'
    end

    it 'does not add with wrong account type' do
      res, op = NetworkAccount::Update.run(id: user.id, profile_id: user.profile.id, current_user: user.id, profile: {network_accounts: [{account: 'stravert', account_type: 'flickr'}]})

      res.must_equal false
      op.contract.errors[:'network_accounts.account_type'].must_include 'must be one of: facebook, twitter, linkedin, skype'
    end

    it 'adds with account and type' do
      res, op = NetworkAccount::Update.run(id: user.id, profile_id: user.profile.id, current_user: user.id, profile: {network_accounts: [{account: 'stravert', account_type: 'twitter'}]})

      res.must_equal true
      op.model.persisted?.must_equal true
    end

    it 'deletes when account is empty' do
      network_account = user.profile.network_accounts.first
      res, op = NetworkAccount::Update.run(id: user.id, profile_id: user.profile.id, current_user: user.id, profile: {network_accounts: [{id: network_account.id, account: '', account_type: network_account.account_type}]})

      res.must_equal true
      op.model.network_accounts.find_by(id: network_account.id).must_be_nil
    end

    it 'changes when account or account type is changed' do
      network_account = user.profile.network_accounts.first
      res, op = NetworkAccount::Update.run(id: user.id, profile_id: user.profile.id, current_user: user.id, profile: {network_accounts: [{id: network_account.id, account: 'erwinstraver', account_type: 'facebook'}]})

      res.must_equal true
      op.model.network_accounts.find_by(id: network_account.id).account.must_equal 'erwinstraver'
    end
  end

end