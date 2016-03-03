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
      !role_meta_data.try(:[], concept).try(:[], operation).nil?
    end

    class Admin < self
      def allow?
        true
      end
    end

    class Moderator < self
      def allow?(concept)
        role_meta_data.try(:[], concept)
      end
    end

  end
end