require 'post/operations'
require 'post/post_form'
require 'post_util/close'
require 'post/published_collection'
require 'abstract_post/property_type'
require 'abstract_post/properties'
require 'recollect/policy_filter'

class Blog < ActiveRecord::Base
  class Create < Post::Base
    include Model
    include Trailblazer::Operation::Policy
    include AbstractPost::Properties
    # include PostUtil::Comments, TODO:

    builds do |options|
      JSON if options[:format] =~ 'json'
    end

    model Blog, :create
    policy Blog::Policy, :create?

    contract PostForm

    properties AbstractPost::PropertyType.find(Blog), property: :post

    class JSON < self
      extend Representer::DSL
      include Representer::Rendering, Responder

      representer PostRepresenter do
        property :id
      end
    end

  end

  class Update < Create
    builds -> (params) do
      JSON if params[:format] =~ 'json'
    end

    action :update

    policy Blog::Policy, :edit_and_owner?

    class JSON < Create::JSON
      action :update
    end
  end

  class Show < Create
    action :find
    policy Blog::Policy, :show?
  end

  class Index < Trailblazer::Operation
    include Collection
    include Model

    model Blog

    collection :published, collection: PublishedCollection do
      include Recollect::Collection::PolicyFilter
      include UserUtil::CurrentUser

      policy_filter Blog::Policy, :show?
    end
  end

  class Preview < Post::Base
    include Callback, Dispatch
    include AbstractPost::Properties
    include Model

    model Blog

    contract PostForm
    properties AbstractPost::PropertyType.find(Blog), property: :post

    def process(params)
      contract.send(:deserialize, params[:blog])
      contract.sync
      dispatch!(:before_save)
      self
    end

    def model!(params)
      params.has_key?(:id) ? Blog.find(params[:id]) : Blog.new
    end

  end

  class Close < Post::Base
    include Callback, Dispatch, Model
    include AbstractPost::Properties
    include PostUtil::Close

    model Blog
    contract PostForm
    properties AbstractPost::PropertyType.find(Blog), property: :post

    def model!(params)
      params.has_key?(:id)? Blog.find(params[:id]) : Blog.new
    end

  end

  class Upload < Post::Upload

    def model!(params)
      params.has_key?(:id)? Blog.find(params[:id]).post : Post.new
      # Blog.find(params[:id]).post
    end
  end

end