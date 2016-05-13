module AbstractPost::Properties

  def self.included(base)
    base.extend Uber::InheritableAttr
    base.inheritable_attr :_properties
    base._properties = []

    base.extend ClassMethods
  end

  module ClassMethods
    def properties(*args)
      properties = args
      class_eval do
        self._properties = properties

        contract do
          include Reform::Form::Coercion
          property :post, inherit: true do
            properties.each do |property|
              property property.name, virtual: true, type: Kernel.const_get(property.type)
            end
          end
        end
      end
    end
  end

  def properties
    self.class._properties
  end

end
