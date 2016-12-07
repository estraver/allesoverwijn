require 'attachment/profile_attachment'

class Profile::Cell < Cell::Concept
  class Photo < Cell::Concept
    extend Uber::Delegates
    include Cell::ImageCell

    delegates :model, :photo_meta_data

    attachment :photo, ProfileAttachment

  end
end