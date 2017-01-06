module Profile::Cell
  class Sidebar < Trailblazer::Cell
    property :name
    property :created_at
    property :roles
    property :profile

    include ::Cell::CreatedAtCell

    def online?
      true # FIXME:
    end

    def editable?
      parent_controller.send(:action_name).eql? 'edit'
    end

  end
end