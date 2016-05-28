require 'uber/delegates'

module Cell
  module ImageCell
    # extend Paperdragon::Model::Reader
    # processable_reader :photo
    # property :photo_meta_data
    #
    # def thumb
    #   image_tag photo[:thumb].url if photo.exists?
    # end
    #
    # def profile_picture
    #   img = photo.exists? ? photo[:profile_picture].url : image_url('/assets/unknown.jpg')
    #   image_tag img, :class => %w(profile-img img-responsive centerblock)
    # end


    def self.attachments(image, attachments = [])
      Module.new do
        extend Paperdragon::Model::Reader

        processable_reader image.to_sym

        attachments.each do | attachment |
          define_method(attachment.to_sym) do |*args|
            options = args.extract_options!
            img = self.send(image.to_sym)
            if img.exists? || options[:blank_image]
              image_tag img.exists? ? img[attachment.to_s].url : image_url(options[:blank_image]), class: options[:class]
            else
              ''
            end
          end
        end
      end
    end

  end
end