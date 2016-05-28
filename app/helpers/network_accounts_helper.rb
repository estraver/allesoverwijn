module NetworkAccountsHelper
  def account_type_options
    NetworkAccount.account_types.keys.map do | account_type |
      [account_type, account_type, data: { icon: "fa fa-#{account_type} fa-fw"}]
    end
  end
end
