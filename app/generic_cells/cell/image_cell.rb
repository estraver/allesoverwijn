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
      end
    end

    def method_missing(method, *args, &block)
      options = args.extract_options!
      img = self.send(self.class._image)
      if !img.nil? && (img.exists? || options[:blank_image])
        # FIXME: Bug in image_url? It generates wrong path
        # image_tag img.exists? ? img[method].url : options[:blank_image], class: options[:class]
        tag :image, src: img.exists? ? img[method].url : "/assets/#{options[:blank_image]}", class: options[:class]
      else
        ''
      end
    end
  end
end