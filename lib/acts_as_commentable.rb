module ActiveRecord
  module ActsAsCommentable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_commentable

        class_eval <<-EOV
          include ActiveRecord::ActsAsCommentable::InstanceMethods

          has_many :comments, as: :commentable, dependent: :destroy, validate: true, autosave: true

          scope :commented_by, ->(commentator) { Comment.where(commentator: commentator) }
        EOV
      end
    end

    module InstanceMethods

      def owned_by?(commentator)
        if commentator.instance_of? Fixnum
          self.commentator.id == commentator
        else
          self.commentator == commentator
        end
      end

      protected

    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::ActsAsCommentable