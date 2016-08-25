# require_dependency 'abstract_post/abstract_post'
# require_dependency 'abstract_post/content_form'
# require_dependency 'abstract_post/properties'
require_dependency 'user_util/current_user'
require_dependency 'post/published_collection'

module AbstractPost
  class Post::Create < Trailblazer::Operation
    include Callback#, Representer
    include UserUtil::CurrentUser
    # include AbstractPost::Properties
    # include Representer::Deserializer::Hash

    # builds -> (params) do
    #   JSON if params[:format] =~ 'json'
    # end

    callback :before_save do
      on_change :auto_schedule_post!, property: :post_schedule
      on_change :categories_change!
      on_change :content_change!

    end

    private

    def params!(params)
      model_key = params.first[0]
      params[model_key][:post].merge! post_contents: {}
      %w(title article locale author).map do | prop |
        params[model_key][:post][:post_contents].merge! Hash[prop.to_sym, params[model_key][:post][prop.to_sym] ]
      end
      params
    end

    # attr_reader :post

    # def setup_model!(params)
    #   res = super(params)
    #   @post ||= AbstractPost::Entry.build(model, {current_user: current_user, properties: properties})
    #   @post.sync # Sync defaults to model
    #   # assign_content!(model.post, @post.post)
    #   res
    # end

    # def contract!(*args)
    #   contract_class.new(model, post: {title: @post.title, locale: @post.locale, author: @post.author, article: @post.article})
    #
    # end

    def content_change!(contract, op)
      # assign_content!(@post.post, contract.post)
      # # @post.post.published = contract.post.published
      # # @post.post.published_on = contract.post.published_on
      #
      # properties.each do | field |
      #   @post.post.send("#{field.name}=".to_sym, contract.post.public_send(field.name.to_sym))
      # end
      #
      # AbstractPost::Entry::ContentChange.new(@post).()
      # @post.sync
    end

    def auto_schedule_post!(contract, op)
      contract.post.published_on = Date.today if contract.post_schedule.eql? 'auto'
    end

    def categories_change!(contract, op)
      ids = contract.post.categories.collect { | category | category.id.to_s }

      # Add new category to categories unless it already exists
      contract.post.category_ids.each do | category_id |
        contract.post.categories << Category.find(category_id) unless ids.include?(category_id)
      end

      # Delete category not include in the list
      contract.post.categories.each do | category |
        contract.post.categories.delete(category) unless contract.post.category_ids.include?(category.id.to_s)
      end
    end

    def assign_content!(target_content, base_content)
      target_content.title = base_content.title
      target_content.article = base_content.article
      target_content.author = base_content.author
      target_content.locale = base_content.locale
    end

    # class JSON < self
    #   representer do
    #     property :title
    #     property :author
    #     property :locale
    #     property :article
    #
    #     collection :tags do
    #       property :name
    #     end
    #
    #     collection :categories do
    #       property :id
    #     end
    #
    #     # FIXME: deserialize picture_meta_data
    #     # property :picture_meta_data #, deserializer: {writeable: false}
    #
    #     property :post_schedule, virtual: true
    #     property :category_ids, virtual: true, default: []
    #
    #     # properties *PropertyType.find(Post)
    #   end
    # end

  end

  class Post::Index < Trailblazer::Operation
    include Collection
    include Model
    include UserUtil::CurrentUser

    collection :published, collection: AbstractPost::PublishedCollection
  end

end
