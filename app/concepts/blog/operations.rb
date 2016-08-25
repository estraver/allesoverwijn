require_dependency 'post/operations'
require_dependency 'post/post_form'
require_dependency 'transfer/operations'
require_dependency 'attachment/post_attachment'

class Blog < ActiveRecord::Base
  class Create < Post::Create
    include Model#, Policy
    include Trailblazer::Operation::Policy
    # include PostUtil::Comments, TODO:

    model Blog, :create
    policy Blog::Policy, :create?

    contract AbstractPost::PostForm

    def process(params)
      validate(params[:blog]) do | contract |
        dispatch!(:before_save)
        contract.save
      end
    end

    def policy?(model, operation)
      Blog::Policy.new(current_user.id, model).(operation)
    end

    class Close < self
      # callback :changed? do
      #   on_change :set_content_changed!
      # end

      def process(params)
        @content_changed = false
        confirmed = params.delete(:confirmed)
        contract.send(:deserialize, params[:blog])
        dispatch!(:changed?)

        return invalid! if @content_changed and !confirmed
        self
      end

      private

      attr_reader :content_changed

      def set_content_changed!(contract, op)
        @content_changed = true
      end
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

    # collection do
      # where -> { joins(contents: :properties).where('properties.name = ? AND properties.value = ?', :published, true).distinct }
      # where ['properties.name = ? AND properties.value = ?', :published, true]
      # where do
      #   and do
      #     equals :name, :published
      #     equals :value, true
      #   end
      # end
      # where do
      #   joins :contents do
      #     joins: properties do
      #       and do
      #          name: :published
      #          value: true
      #       end
      #     end
      #   end
      #   distinct
      # end
      #
      # where :published
      # order :published_on

    # end

    def policy?(model, operation)
      Blog::Policy.new(current_user.id, model).(operation)
    end
  end

  class Upload < Transfer::Upload
    contract do
      processable_writer :image, PostAttachment
    end

    representer do
      include Representable::JSON

      property :image_meta_data
      property :header_url, exec_context: :decorator
      property :sidebar_url, exec_context: :decorator
      property :original_url, exec_context: :decorator

      private

      def url_for(style)
        image = PostAttachment.new represented.image_meta_data
        image[style].url
      end

      def header_url
        url_for(:header)
      end

      def sidebar_url
        url_for(:sidebar)
      end

      def original_url
        url_for(:original)
      end
    end

  end

end