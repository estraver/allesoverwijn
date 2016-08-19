module Permission
  class Authorisation < Disposable::Twin
    feature Builder
    feature Default
    feature Sync

    builds -> (model, options) do
      return Admin if model.name.eql? 'admin'
      return Moderator if model.name.eql? 'moderator'
    end

    property :name
    property :role_meta_data, default: Hash.new

    def allow?(concept, operation)
      return true unless role_meta_data.try(:[], concept).try(:[], operation).nil?
      return true unless role_meta_data.try(:[], concept).try(:[], :all).nil?
      false
    end

    class Admin < self
      def allow?(concept, operation)
        true
      end
    end

    class Moderator < self
      def allow?(concept, operation)
        role_meta_data.try(:[], concept)
      end
    end

  end
end