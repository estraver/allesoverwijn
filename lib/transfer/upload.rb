module Transfer
  module Upload
    def self.included(base)
      base.extend Uber::InheritableAttr
      base.inheritable_attr :_image_name
      base._image_name = ''

      base.extend ClassMethods
    end

    module ClassMethods
      def image(name, options = {})
        class_eval do
          self._image_name = name

          file_size = options.delete(:file_size) || 1.megabyte
          file_types = options.delete(:file_types) || %w(image/png image/jpeg)
          thumbs = options.delete(:thumbs) || []
          thumb_class = options.delete(:thumb_class) || Paperdragon::Attachment

          contract do
            property :file, virtual: true

            extend Paperdragon::Model::Writer
            processable_writer :"#{name}", thumb_class
            property :"#{name}_meta_data", deserializer: {writeable: false}

            validation :default do
              configure do
                config.messages_file = 'config/dry_error_messages.yml'

                def file_size_ok?(file_size, file)
                  file.size < file_size
                end

                def file_type_ok?(file_types, file)
                  mime_type = FileMagic.open(:mime) { |fm| fm.buffer(file.read, true) }
                  file.rewind

                  file_types.include? mime_type
                end
              end

              required(:file).filled

              rule(file_type: [:file]) do | file |
                file.filled? & file.file_type_ok?(file_types)
              end

              rule(file_size: [:file]) do | file |
                file.filled? & file.file_size_ok?(file_size)
              end
            end
          end

          representer do
            include Representable::JSON

            property :"#{name}_meta_data"
            property :success, getter: ->(user_options:, **) { user_options[:success] }

            (thumbs + [{name: :original}]).each do |thumb|
              property :"#{thumb[:name]}_url", exec_context: :decorator

              define_method(:"#{thumb[:name]}_url") do
                image = thumb_class.new represented.send("#{name}_meta_data")
                image[thumb[:name].to_sym].url
              end
            end
          end

          define_method(:process) do |params|
            validate(params[name]) do | contract |
              upload_image!(params[:sizes] || thumbs)
              contract.save
            end
          end

          define_method(:upload_image!) do | sizes |
            sizes ||= []
            contract.send(:"#{name}!", contract.file) do |ff|
              ff.process!(:original)
              sizes.each do |size|
                ff.process!(size[:name].to_sym) { |job| job.thumb!(size[:size]) }
              end
            end
          end
        end
      end
    end
  end
end