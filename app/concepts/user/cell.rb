class User::Cell < Cell::Concept
  property :name
  property :created_at
  property :roles

  def show
    render
  end

end
