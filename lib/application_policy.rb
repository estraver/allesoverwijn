require_dependency 'permission'

class ApplicationPolicy
  def initialize(user, model)
    @user, @model = user, model
  end

  def operation_allowed?(concept, operation)
    user = User.find(@user)
    permissions = user.roles.collect { |role| ::Permission::Authorisation.new(role) }
    permissions.collect { | permission | permission.allow?(concept.to_sym, operation.to_sym) }.any?
  end

  def owner?
    return @user.id == @model.id if @user.class.name.eql? @model.class.name
    return @user.id == @model.user_id if @model.respond_to? :user_id
    false
  end

  def method_missing(method_sym, *args, &block)
    operation = method_sym.to_s.delete('?')
    self.instance_eval <<-END
        def #{method_sym}
          operation_allowed? self.class.name.deconstantize.downcase, '#{operation}'
        end
    END

    send(method_sym, *args, &block)
  end

end