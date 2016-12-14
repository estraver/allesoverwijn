class User::Cell < Cell::Concept
  property :name
  property :created_at
  property :roles

  def show
    render
  end

  class Sidebar < Cell::Concept
    property :name
    property :created_at
    property :roles
    property :profile

    inherit_views User::Cell

    include ::Cell::CreatedAtCell

    def show
      render :sidebar
    end

    def online?
      true # FIXME:
    end

    def editable?
      parent_controller.send(:action_name).eql? 'edit'
    end


  end

end
