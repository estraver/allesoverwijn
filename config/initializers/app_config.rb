require 'app_config'

AppConfig.configure do | config |
  config.setting namespace: :welcome,
                 keys: [{name: :title, default: [{value: 'Welcome', language: 'en'}]},
                        {name: :content, default: [{value: 'Content on first page', language: 'en'}]},
                        {name: :statement, default: [{value: 'Website statement', language: 'en'}]}]
end