require 'post/operations'
require 'post/post_form'
require 'post_util/close'
require 'post/published_collection'
require 'abstract_post/property_type'
require 'abstract_post/properties'

class Blog < ActiveRecord::Base
  class Create < Post::Create
    include Model#, Policy
    include Trailblazer::Operation::Policy
    include PostUtil::Close
    include AbstractPost::Properties
    # include PostUtil::Comments, TODO:

    model Blog, :create
    policy Blog::Policy, :create?

    contract PostForm

    properties AbstractPost::PropertyType.find(Blog), property: :post

    # def process(params)
    #   validate(params[:blog]) do | contract |
    #     dispatch!(:before_save)
    #     contract.save
    #   end
    # end

    def policy?(model, operation)
      Blog::Policy.new(current_user.id, model).(operation)
    end

    class Preview < self
      def process(params)
        contract.send(:deserialize, params[:blog])
        dispatch!(:before_save)
        self
      end
    end

  end

  class Update < Create
    action :update

    policy Blog::Policy, :edit_and_owner?

    class Close < Create::Close
      action :update
    end

    class Preview < Create::Preview
      action :update
    end
  end

  class Show < Create
    action :find
    policy Blog::Policy, :show?
  end

  class Index < Post::Index
    model Blog
    
    def policy?(model, operation)
      Blog::Policy.new(current_user.id, model).(operation)
    end
  end

  # class Upload < Transfer::Upload
  #   include Representer
  #
  #   contract do
  #     processable_writer :image, PostAttachment
  #   end
  #
  #   representer do
  #     include Representable::JSON
  #
  #     property :image_meta_data
  #     property :header_url, exec_context: :decorator
  #     property :sidebar_url, exec_context: :decorator
  #     property :original_url, exec_context: :decorator
  #
  #     private
  #
  #     def url_for(style)
  #       image = PostAttachment.new represented.image_meta_data
  #       image[style].url
  #     end
  #
  #     def header_url
  #       url_for(:header)
  #     end
  #
  #     def sidebar_url
  #       url_for(:sidebar)
  #     end
  #
  #     def original_url
  #       url_for(:original)
  #     end
  #   end
  #
  # end

end