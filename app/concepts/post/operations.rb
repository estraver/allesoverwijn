require_dependency 'lib/abstract_post/abstract_post'
require_dependency 'lib/abstract_post/content_form'
require_dependency 'lib/abstract_post/properties'
require_dependency 'lib/user_util/current_user'
require_dependency 'post/published_collection'

module AbstractPost
  class Post::Create < Trailblazer::Operation
    include Callback
    include UserUtil::CurrentUser
    include Properties

    callback :before_save do
      on_change :auto_schedule_post!, property: :post_schedule
      # on_change :upload_image!, property: :file
      on_change :content_change!
    end

    contract do
      feature Disposable::Twin::Persisted

      property :post, form: ContentForm
      property :post_schedule, virtual: true

    end

    properties *PropertyType.find(Post)

    private

    attr_reader :post

    def setup_model!(params)
      super(params)
      @post ||= AbstractPost::Entry.build(model, {current_user: current_user, properties: properties})
      @post.sync # Sync defaults to model
    end

    def content_change!(contract, op)
      assign_content!(@post.post, contract.post)
      @post.post.published = contract.post.published
      @post.post.published_on = contract.post.published_on

      # property_fields.each do | field |
      #   @post.content.send(field.to_sym, contract.content.send(field.to_sym))
      # end

      AbstractPost::Entry::ContentChange.new(@post).()
      @post.sync
    end

    def auto_schedule_post!(contract, op)
      contract.post.published_on = Date.today if contract.post_schedule.eql? 'auto'
    end

    def assign_content!(target_content, base_content)
      target_content.title = base_content.title
      target_content.article = base_content.article
      target_content.author = base_content.author
      target_content.locale = base_content.locale
    end

    class Upload < self
      include Responder, Representer
      include Representer::Deserializer::Hash

      builds -> (params) do
        JSON if params[:format] =~ 'json'
      end

      contract do
        property :post do
          property :file, virtual: true
          validates :file, file_size: {less_than: 1.megabyte},
                    file_content_type: {allow: %w(image/jpeg image/png)}

          extend Paperdragon::Model::Writer
          processable_writer :picture
          property :picture_meta_data, deserializer: {writeable: false}
        end

      end

      # callback :before_save do
      #   on_change :upload_image!, property: :file
      # end

      def process(params)
        validate(params[:file]) do
          upload_image!
        end
      end

      private

      def upload_image!
        contract.post.photo!(contract.post.file) do |ff|
          ff.process!(:original)
          ff.process!(:thumb) { |job| job.thumb!('50x50#') }
          ff.process!(:post_edit_picture) { |job| job.thumb!('159x159#') }
        end
      end

      class JSON < self
        representer do
          property :picture_meta_data
          property :post_picture_url, exec_context: :decorator
          property :retained_picture

          private

          def post_picture_url
            picture = Paperdragon::Attachment.new represented.picture_meta_data
            picture[:post_edit_picture].url
          end
        end
      end

    end

  end

  class Post::Index < Trailblazer::Operation
    include Collection
    include Model
    include UserUtil::CurrentUser

    collection :published, collection: AbstractPost::PublishedCollection
  end

end
