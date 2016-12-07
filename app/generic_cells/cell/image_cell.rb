require 'uber/delegates'

module Cell
  module ImageCell
    def self.included(base)
      base.extend Uber::InheritableAttr
      base.extend Paperdragon::Model::Reader
      base.inheritable_attr :_image
      base._image = nil

      base.extend ClassMethods
    end

    module ClassMethods
      def attachment(image, attachment_class)
        self._image = image

        self.send(:processable_reader, image.to_sym, attachment_class)

          # processable_reader image.to_sym

          # attachments.each do | attachment |
          #   define_method(attachment) do |*args|
          #     # self.send(:define_method, attachment) do |*args|
          #     options = args.extract_options!
          #     img = self.send(image.to_sym)
          #     if img.exists? || options[:blank_image]
          #       image_tag img.exists? ? img[attachment.to_sym].url : image_url(options[:blank_image]), class: options[:class]
          #     else
          #       ''
          #     end
          #   end
          # end

        # end

      end
    end

    def method_missing(method, *args, &block)
      # Rails.logger.info method
      options = args.extract_options!
      # Rails.logger.info image_path("assets/#{options[:blank_image]}")
      img = self.send(self.class._image)
      if img.exists? || options[:blank_image]
        # FIXME: Bug in image_url? It generates wrong path
        # image_tag img.exists? ? img[method].url : options[:blank_image], class: options[:class]
        tag :image, src: img.exists? ? img[method].url : "/assets/#{options[:blank_image]}", class: options[:class]
      else
        # send(method, *args, &block)
        ''
      end
    end
      # self.send(:define_method, method) do | *method_args |
      # # define_method(method) do |*args|
      #   options = method_args.extract_options!
      #   img = self.send(self.class._image)
      #   if img.exists? || options[:blank_image]
      #     image_tag img.exists? ? img[method].url : image_url(options[:blank_image]), class: options[:class]
      #   else
      #     ''
      #   end
      #
      # end
      #
      # send(method, *args, &block)
    # end
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


    # def self.attachments(image, attachments = [])
    #   Module.new do
    #     extend Paperdragon::Model::Reader
    #
    #     processable_reader image.to_sym
    #
    #     attachments.each do | attachment |
    #       define_method(attachment.to_sym) do |*args|
    #         options = args.extract_options!
    #         img = self.send(image.to_sym)
    #         if img.exists? || options[:blank_image]
    #           image_tag img.exists? ? img[attachment.to_sym].url : image_url(options[:blank_image]), class: options[:class]
    #         else
    #           ''
    #         end
    #       end
    #     end
    #   end
    # end

  end
end