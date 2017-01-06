module Recollect::Collection::PolicyFilter

  def self.included(base)
    extend Uber::InheritableAttr
    base.inheritable_attr :policy
    base.inheritable_attr :action
    # base.inheritable_attr :collection

    base.extend Policy
    # base.extend Recollect::Collection::Setup
  end

  module Policy
    def policy_filter(policy, action, options = {})
      self.policy = policy
      self.action = action

      filter = options.delete(:filter) || :auto
      include AutoFilter if filter.eql?(:auto)
    end
  end

  # module Setup
  #   def filter_collection!(collection, *args)
  #     self.class.collection = collection
  #     current_user = @params.fetch(:current_user)
  #     collection.select { | model | self.class.policy.new(current_user, model).(self.class.action) }
  #   end
  # end

  # include Setup

  # def count
  #   self.class.collection.except(:limit, :offset).count
  # end

  module AutoFilter
    def collection
      filtered
    end
  end

  def filtered
    current_user = @params.fetch(:current_user)
    @collection.select { | model | self.class.policy.new(current_user, model).(self.class.action) }
  end
end