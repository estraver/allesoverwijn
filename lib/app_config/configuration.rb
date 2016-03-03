require 'app_config/namespace'

module AppConfig
  class Configuration
    attr_accessor :namespaces, :config_sources

    def initialize
      @namespaces = {}
      @config_sources = []
    end

    def setting(*args)
      options = args.extract_options!
      @namespaces[options[:namespace]] ||= Namespace.new(options[:namespace], options[:keys])
    end

    def add_config_source(*files)
      [files].flatten.compact.uniq.each do |file|
        @config_sources << YAMLSource.new(file.to_s)
      end
    end

    def load
      @config_sources.each do | config_source |
        config = config_source.load
        config.keys.each { | namespace |
          keys = []
          config[namespace].each { |name, value|
            # keys: [{name: :title, default: [{value: 'Welcome', language: 'en'}, ... ]}, ... ]

            defaults = value.keys.map { | language |
              {value: value[language], language: language}
            }
            keys.push({name: name.to_sym, default: defaults})
          }
          if @namespaces[namespace.to_sym]
            @namespaces[namespace.to_sym].add_or_update_keys(keys)
          else
            @namespaces[namespace.to_sym] = Namespace.new(namespace.to_sym, keys)
          end

        }
      end
    end

    private
  end
end