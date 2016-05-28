require_dependency 'abstract_post/abstract_post'
require_dependency 'abstract_post/content_form'
require_dependency 'abstract_post/properties'
require_dependency 'user_util/current_user'
require_dependency 'post/published_collection'

module AbstractPost
  class Post::Create < Trailblazer::Operation
    include Callback
    include UserUtil::CurrentUser
    include Properties

    callback :before_save do
      on_change :auto_schedule_post!, property: :post_schedule
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
      # @post.post.published = contract.post.published
      # @post.post.published_on = contract.post.published_on

      # TODO: public_send??
      properties.each do | field |
        @post.content.public_send(field.to_sym, contract.content.public_send(field.to_sym))
      end

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

  end

  class Post::Index < Trailblazer::Operation
    include Collection
    include Model
    include UserUtil::CurrentUser

    collection :published, collection: AbstractPost::PublishedCollection
  end

end
