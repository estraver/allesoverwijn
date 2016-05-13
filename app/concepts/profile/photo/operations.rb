require_dependency 'profile/operations'

class Profile < ActiveRecord::Base
  class Photo
    class Create < Profile::Create
      include Model, Responder, Representer, Trailblazer::Operation::Policy
      include Representer::Deserializer::Hash
      include Dispatch

      model Profile, :create
      policy Profile::Policy, :create?
    end

    class Update < Create
      action :update
      policy Profile::Policy, :owner?

      builds -> (params) do
        JSON if params[:format] =~ 'json'
      end

      contract do
        feature Disposable::Twin::Persisted

        property :file, virtual: true
        validates :file, file_size: {less_than: 1.megabyte},
                  file_content_type: {allow: ['image/jpeg', 'image/png']}

        extend Paperdragon::Model::Writer
        processable_writer :photo
        property :photo_meta_data, deserializer: {writeable: false}

      end

      callback :before_save do
        on_change :upload_image!, property: :file
      end

      def process(params)
        validate(params[:photo]) do |f|
          dispatch!(:before_save)
          f.save
        end
      end

      private

      def upload_image!(contract, options)
        contract.photo!(contract.file) do |ff|
          ff.process!(:original)
          ff.process!(:thumb) { |job| job.thumb!('50x50#') }
          ff.process!(:profile_picture) { |job| job.thumb!('159x159#') }
        end
      end

      class JSON < self
        representer do
          property :photo_meta_data
          property :profile_picture_url, exec_context: :decorator

          private

          def profile_picture_url
            photo = Paperdragon::Attachment.new represented.photo_meta_data
            photo[:profile_picture].url
          end
        end
      end
    end
  end
end