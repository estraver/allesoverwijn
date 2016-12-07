module AbstractPost
  class PropertyType

    class << self
      def setup!(config = 'config/property_types.yml')
        config = YAML.load_file(config)

        Rails.cache.fetch('objects/property_types', force: true) do
          build_property_types(config)
        end
      end

      def find(model)
        model_properties = Rails.cache.fetch('objects/property_types').detect do |property_types|
          property_types[:model].eql? model.name.downcase.to_sym
        end

        model_properties.nil? ? [] : model_properties[:properties]
      end

      private

      def build_property_types(config)
        config.keys.map do | model |
          {model: model, properties: build_property_list(model, config).map { | property | Property.new(property[:name], property[:type], property[:default]) }}
        end
      end

      def build_property_list(model, config)
        properties = []
        properties |= config[model][:types] if config[model].key? :types
        properties |= config[config[model][:inherit].to_sym][:types] if config[model].key? :inherit
        properties
      end
    end

    class Property
      attr_reader :name, :type, :default

      def initialize(name, type, default = nil)
        @name = name
        @type = type
        @default = default
      end

    end

  end
end