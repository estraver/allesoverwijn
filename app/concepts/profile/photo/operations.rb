require_dependency 'profile/operations'

class Profile < ActiveRecord::Base
  class Contact
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

      contract do
        feature Disposable::Twin::Persisted

        property :file, virtual: true
        validates :file, file_size: { less_than: 1.megabyte },
                  file_content_type: { allow: ['image/jpeg', 'image/png'] }


        extend Paperdragon::Model::Writer
        processable_writer :image
        property :photo, deserializer: {writeable: false}

      end

      callback(:before_save) do
        on_change :upload_image!, property: :file
      end

      def process(params)
        validate(params[:profile]) do |f|
          dispatch!(:before_save)
          f.save
          dispatch!
        end
      end

      private

      def upload_image!(contract)
        contract.image!(contract.file) do |ff|
          ff.process!(:original)
          ff.process!(:thumb) { |job| job.thumb!('120x120#') }
        end
      end

    end
  end
end
