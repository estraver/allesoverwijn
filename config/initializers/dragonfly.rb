require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret '39919d694629630cc818fcb6a23adb31fa3475bdb19e941a6187fb8ca06eedff'

  url_format '/media/:job/:uid'

  datastore :file,
    root_path: Rails.root.join('public/system/images', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
