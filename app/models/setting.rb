class Setting < ActiveRecord::Base
  has_many :setting_contents
  has_one :setting_content, ->(setting) { where locale: setting.new_locale || @@locale || I18n.locale || I18n.default_locale }, class_name: 'SettingContent', validate: true, autosave: true

  attr_accessor :new_locale
  cattr_accessor :fields, :locale, instance_accessor: false

  @@fields = [:value, :locale, :value_type]

  @@fields.each { |field|
    delegate field, "#{field}=", to: :setting_content, allow_nil: true
  }

  validates_presence_of :key, :namespace
  validates_uniqueness_of :key, scope: [:namespace]
  validates_associated :setting_content

  after_initialize do |setting|
    Rails.logger.info "after_initialize"
    setting.build_setting_content if setting.new_record?
    if setting.setting_content.nil? && !setting.new_record?
      @@locale = setting.setting_contents.first.locale
      setting.setting_content true
    end
  end

  after_validation :propagate_setting_content_errors

  def locale=(new_locale)
    Rails.logger.info "locale"
    unless setting_content.locale.eql?(new_locale)
      @new_locale = new_locale
      if new_record?
        setting_content.locale = new_locale
      else
        setting_content(true)

        build_setting_content if setting_content.nil?
        setting_content.locale = new_locale
      end
    end
  end

  protected

  def propagate_setting_content_errors
    if errors[:setting_content].size > 0
      @@fields.each { |field|
        setting_content.errors[field].each { |error|
          errors.add(field, error)
        }
      }
    end
  end
end
