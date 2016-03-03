require 'app_config/configuration'
require 'app_config/yaml_source'

module AppConfig
  class << self
    attr_writer :configuration
  end

  class MissingNamespace < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.method_missing(method_sym, *args, &block)
    return missing_namespace("Namespace '#{method_sym}' not defined!") unless @configuration.namespaces.has_key? method_sym

    self.class.class_eval <<-END
      def #{method_sym}
        @configuration.namespaces["#{method_sym}".to_sym]
      end
    END

    self.send(method_sym, *args, &block)
  end

  def self.all
    @configuration.namespaces.values.each { |namespace|
      yield namespace
    }
  end

  def self.load_config(*files)
    @configuration ||= Configuration.new

    @configuration.add_config_source(*files)
    @configuration.load
  end

  def self.default_config_files(config_root)
    [ File.join(config_root, 'app_config.yml').to_s ]
  end

  def self.missing_namespace(msg)
    raise MissingNamespace, msg
  end

end

require('app_config/railtie') if defined?(Rails)