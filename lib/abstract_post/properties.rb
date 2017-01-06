module AbstractPost::Properties

  def self.included(base)
    base.extend Uber::InheritableAttr
    base.inheritable_attr :_properties
    base._properties = []

    base.extend ClassMethods
  end

  module ClassMethods
    def properties(properties, options = {})
      class_eval do
        self._properties = properties

        if options.empty?
          properties.each do |property|
            if property.default.nil?
              property property.name, virtual: true, type: Kernel.const_get(property.type)
            else
              property property.name, virtual: true, type: Kernel.const_get(property.type), default: property.default
            end
          end
        else
          contract do
            property options[:property], inherit: true do
              properties.each do |property|
                if property.default.nil?
                  property property.name, virtual: true, type: Kernel.const_get(property.type)
                else
                  property property.name, virtual: true, type: Kernel.const_get(property.type), default: property.default
                end
              end
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
