require 'attachment/profile_attachment'

module Profile::Photo
  module Cell
    class Show < Trailblazer::Cell
      extend Uber::Delegates
      include ::Cell::ImageCell

      delegates :model, :photo_meta_data

      attachment :photo, ProfileAttachment

    end
  end
end