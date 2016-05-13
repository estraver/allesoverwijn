class TranslationKey

  class << self
    alias_method :original_translation, :translation
  end

  def self.translation(key, locale)
    text = original_translation(key, locale)
    return text if text.nil?
    return YAML::load(text) if text.match /^---.*/ #detect YAML array via ---
    text
  end

end