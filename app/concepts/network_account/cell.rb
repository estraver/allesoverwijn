class NetworkAccount::Cell < Cell::Concept
  property :account_type
  property :account

  def show
    render
  end
end
