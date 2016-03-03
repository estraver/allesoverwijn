require 'fast_gettext/translation_repository/db'
require 'missing_translation_logger'

AVAILABLE_LOCALES = [:nl, :en, :fr]

FastGettext::TranslationRepository::Db.require_models

if Rails.env.development? || Rails.env.test?
  logger = MissingTranslationLogger.new

  repos = [
      FastGettext::TranslationRepository.build('allesoverwijn', type: :db, model: TranslationKey),
      FastGettext::TranslationRepository.build('logger', type: :logger, callback: lambda{|key_or_array_of_ids| logger.call(key_or_array_of_ids)  })
  ]
  FastGettext.add_text_domain 'allesoverwijn', type: :chain, chain: repos
else
  FastGettext.add_text_domain 'allesoverwijn', type: :db, model: TranslationKey
end

FastGettext.default_text_domain = 'allesoverwijn'
FastGettext.available_locales = AVAILABLE_LOCALES # only allow these locales to be set (optional)
# FastGettext.locale = :nl
# FastGettext.default_locale = :en
I18n.locale = :en
I18n.default_locale = :en
I18n.config.available_locales = AVAILABLE_LOCALES