class SettingContent < ActiveRecord::Base
  belongs_to :setting

  validates_presence_of :value, :value_type, :locale
  validates_uniqueness_of :setting_id, scope: [:locale]
  validates_inclusion_of :locale, in: I18n.available_locales.map(&:to_s)
end
