class Profile::Cell < Cell::Concept
  class Photo < Cell::Concept
    extend Paperdragon::Model::Reader
    processable_reader :photo
    property :photo_meta_data

    def thumb
      image_tag photo[:thumb].url if photo.exists?
    end

    def profile_picture
      img = photo.exists? ? photo[:profile_picture].url : image_url('/assets/unknown.jpg')
      image_tag img, :class => %w(profile-img img-responsive centerblock)
    end
  end
end