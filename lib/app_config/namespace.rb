module AppConfig
  class Namespace
    class MissingKey < StandardError; end

    attr_accessor :name, :keys

    def initialize(name, keys)
      @name = name
      @keys = keys
    end

    def method_missing(method_sym, *args, &block)
      setter = /^(\w+)=$/ =~ method_sym.to_s
      key = $1 || method_sym

      return missing_key("Undefined key '#{key.to_sym}' for namespace #{@name}") unless @keys.any? { |k| k.is_a?(Hash) ? k[:name].eql?(key.to_sym) : k.eql?(key.to_sym) }
      instance_variable_set("@#{key}", nil)

      if setter
        create_setter(method_sym, key)
      else
        create_getter(method_sym, key)
      end

      send(method_sym, *args, &block)
    end

    def name
      @name
    end

    def all
      @keys.each do |key|
        yield key
      end
    end

    def add_or_update_keys(keys)
      keys.each { | key |
        existing_key = @keys.detect { |k| k[:name].eql?(key[:name])}
        if existing_key
          existing_key.deep_merge!(key)
        else
          @keys << key
        end
      }
    end

    private

    def create_getter(method_sym, key)
      self.instance_eval <<-END
        def #{method_sym}(locale = nil)
          Setting.locale = locale || I18n.locale
          setting = Setting.where(key: "#{key.to_s}", namespace: "#{@name}").first
          @#{key} = if setting.nil?
            default_value("#{key}", Setting.locale)
          else
            setting.locale.to_sym.eql?(locale || I18n.locale) ? setting.value : default_value("#{key}", locale || I18n.locale)
          end
        end
      END
    end

    def create_setter(method_sym, key)
      self.instance_eval <<-END
        def #{method_sym}(value)
          Setting.locale = I18n.locale
          setting = Setting.where(key: "#{key.to_s}", namespace: "#{@name}").first_or_initialize
          setting.locale = I18n.locale
          setting.value = value
          setting.value_type = value.class
          setting.save!

          @#{key} = setting.value
        end
      END
    end

    def default_value(key, locale)
      unless @keys.include?(key.to_sym)
        key = @keys.detect { |k| k[:name].eql?(key.to_sym)}
        if key.has_key? :default
          default = key[:default].detect { |lang| lang[:language].eql?(locale.to_s) }
          default[:value]
        end
      end
    end

    def missing_key(msg)
      raise MissingKey, msg
    end
  end
end