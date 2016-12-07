# require 'transfer/image'
#
# module Transfer
#   class Upload < Trailblazer::Operation
#     include Model
#     # include Responder, Representer
#     # include Representer::Deserializer::Hash
#
#     # builds -> (params) do
#     #   JSON if params[:format] =~ 'json'
#     # end
#
#     model Image, :create
#
#     contract do
#       property :file, virtual: true
#
#       extend Paperdragon::Model::Writer
#       # processable_writer :image
#       property :image_meta_data, deserializer: {writeable: false}
#
#       validation :default do
#         configure do
#           config.messages_file = 'config/dry_error_messages.yml'
#
#           def file_size_ok?(file)
#             file.size < 1.megabyte
#           end
#
#           def file_type_ok?(file)
#             mime_type = FileMagic.open(:mime) { |fm| fm.buffer(file.read, true) }
#             file.rewind
#
#             %w(image/png image/jpeg).include? mime_type
#           end
#         end
#
#         required(:file).filled(:file_size_ok?, :file_type_ok?)
#       end
#
#
#     end
#
#     def process(params)
#       validate(params[:image]) do
#         upload_image!(params[:sizes])
#         contract.sync
#       end
#     end
#
#     private
#
#     def upload_image!(sizes = [])
#       sizes ||= []
#       contract.image!(contract.file) do |ff|
#         ff.process!(:original)
#         sizes.each do | name, size |
#           ff.process!(name.to_sym) { |job| job.thumb!(size)}
#         end
#       end
#     end
#
#   end
# end