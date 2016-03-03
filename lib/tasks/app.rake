namespace :app do
  desc 'Create application settings (only non-existing)'
  task settings: [:environment] do
    AppConfig.all do |namespace|
      namespace.all do |key|
        if Setting.exists?(key: key[:name], namespace: namespace.name)
          setting = Setting.where(key: key[:name], namespace: namespace.name).take
        else
          setting = Setting.new
          setting.key = key[:name]
          setting.namespace = namespace.name
        end

        key[:default].each do |default|
          begin
            setting.setting_contents.find_by_locale!(default[:language])
          rescue ActiveRecord::RecordNotFound
            setting.locale = default[:language]
            setting.value = default[:value]
            setting.value_type = default[:value].class.to_s
          end
        end

        setting.save!
      end
    end
  end
end
