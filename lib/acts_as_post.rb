module ActiveRecord
  module ActsAsPost
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_post(*args)
        options = args.extract_options!
        comments_allowed = options[:comments_allowed] || false

        class_eval do
          include ActiveRecord::ActsAsPost::InstanceMethods

          has_one :post, :as => :page, :dependent => :destroy, :validate => true, :autosave => true

          scope :recent, -> { joins(:post).where('posts.published_on >= ?', 1.week.ago) }
          scope :published, -> { joins(:post).where('posts.published = true') }
          scope :featured, -> { joins(:post).where('posts.featured = true') }

          scope :authored_by, ->(author) { Post.where(author: author) }

          validates_associated :post

          before_save :set_comment_allowed
          after_initialize { self.post = Post.new if self.new_record? }
          after_validation :propagate_errors_from_post

          class << self; attr_accessor :fields, :comments_allowed; end

          @fields = [:title, :article, :locale, :author]
          @comments_allowed = comments_allowed

        end

        if comments_allowed
          require_dependency 'acts_as_commentable'

          class_eval do
            acts_as_commentable
          end
        end
      end
    end

    module InstanceMethods
      def method_missing(method_sym, *arguments, &block)
        if post.respond_to?(method_sym)
          self.class.delegate method_sym, to: :post, allow_nil: true
          self.send(method_sym, *arguments, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_sym, private_instance = false)
        post.respond_to?(method_sym) || super
      end

      def owned_by?(author)
        if author.instance_of? Fixnum
          self.author.id == author
        else
          self.author == author
        end
      end

      def allow_comments?
        self.class.comments_allowed && post.comments_allowed
      end

      protected
      # def ensure_it_has_no_comments
      #   self.comments.empty?
      # end

      def set_comment_allowed
        post.comments_allowed = allow_comments?
        true
      end

      def propagate_errors_from_post
        if errors[:post].size > 0
          self.class.fields.each { |field|
            post.errors[field].each { |error|
              errors.add(field, error)
            }
          }
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::ActsAsPost