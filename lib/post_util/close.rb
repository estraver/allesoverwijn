# require 'post_util/post_util'

module PostUtil
  module Close

    def self.included(base)
      base.class_eval do
        callback :changed? do
          on_change :set_content_changed!
        end

        def process(params)
          model_name = model.class.to_s.downcase.to_sym
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
          @content_changed = [ contract.post.author.changed?(:id),
            contract.post.changed?(:title),
            contract.post.changed?(:locale),
            contract.post.changed?(:article),
            contract.post.tags.map { |tag| tag.changed?(:tag) }.inject(false, :|)
          ].inject(false, :|)

        end
      end
    end
  end
end
