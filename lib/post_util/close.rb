# require 'post_util/post_util'

module PostUtil
  module Close

    def self.included(base)
      base.class_eval <<-EOV
        class Close < self
          callback :changed? do
            on_change :set_content_changed!
          end

          def process(params)
            model_name = current_model.to_s.downcase.to_sym
            @content_changed = false
            confirmed = params.delete(:confirmed)
            contract.prepopulate!(params: params)
            contract.send(:deserialize, params[model_name])

            dispatch!(:changed?)

            return invalid! if @content_changed and !confirmed
            self
          end

          private

          attr_reader :content_changed

          def set_content_changed!(contract, op)
            @content_changed = contract.post.changed?(:title) || contract.post.changed?(:locale) || contract.post.author.changed?(:id) || contract.post.changed?(:article) || contract.post.changed?(:tags)
          end
        end
      EOV
    end
  end
end
