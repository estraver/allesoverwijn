module AppConfig
  class Railtie < Rails::Railtie
    config.before_configuration {
      # Manually load the custom initializer before everything else
      app_config = Rails.root.join('config', 'initializers', 'app_config.rb')
      require app_config if File.exist?(app_config)

      AppConfig.load_config(AppConfig.default_config_files(Rails.root.join('config')), I18n.default_locale)
    }
  end
end