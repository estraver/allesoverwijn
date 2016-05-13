require_dependency 'permission'

class ApplicationPolicy
  alias_method :call, :send

  def initialize(user_id, model)
    @user_id, @model = user_id, model
    @concept = self.class.name.deconstantize.constantize.model_name.singular
  end

  def operation_allowed?(concept, operation)
    user = User.find(@user_id)
    permissions = user.roles.collect { |role| ::Permission::Authorisation.build(role) }
    permissions.collect { | permission | permission.allow?(concept.to_sym, operation.to_sym) }.any?
  end

  def owner?
    owner_of? @model
  end

  def owner_of?(model)
    return @user_id == model.id if User.name.eql? model.class.name
    return @user_id == model.user_id if model.respond_to? :user_id
    false
  end

  def create?
    operation_allowed? @concept, :create
  end

  def update?
    operation_allowed? @concept, :update
  end

  def edit?
    update?
  end

  def edit_and_owner?
    edit? and owner?
  end

  def show?
    edit_and_owner? || operation_allowed?(@concept, :show)
  end

end