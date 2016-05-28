require 'transfer/image'

module Transfer
  class Upload < Trailblazer::Operation
    include Model
    include Responder, Representer
    include Representer::Deserializer::Hash

    # builds -> (params) do
    #   JSON if params[:format] =~ 'json'
    # end

    model Image, :create

    contract do
      property :file, virtual: true
      validates :file, file_size: {less_than: 1.megabyte},
                file_content_type: {allow: %w(image/jpeg image/png)}

      extend Paperdragon::Model::Writer
      # processable_writer :image
      property :image_meta_data, deserializer: {writeable: false}

    end

    def process(params)
      validate(params[:image]) do
        upload_image!(params[:sizes])
        contract.sync
      end
    end

    private

    def upload_image!(sizes = [])
      sizes ||= []
      contract.image!(contract.file) do |ff|
        ff.process!(:original)
        sizes.each do | name, size |
          ff.process!(name.to_sym) { |job| job.thumb!(size)}
        end
      end
    end

  end
end