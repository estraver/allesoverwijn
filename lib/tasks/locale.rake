require 'optparse'

namespace :locale do |args|
  def find_or_create_hash(config, arr, value)
    key = arr.shift
    return if key.include? 'Class'
    if arr.size >=1
      begin
        config[key] ||= Hash.new
        find_or_create_hash(config[key], arr, value)
      rescue IndexError
        puts "Warning: #{key} #{key.class.to_s} #{config[key].inspect}"
      end

    else
      begin
        config[key] = value || ''
      rescue IndexError
        puts "Warning: #{key} contains #{config[key].inspect}"
      end
    end
  end

  desc 'Extract translation to yaml from project sources'
  task extract: [:environment]  do
  end

  desc 'Export the locale from the database to a YAML file'
  task export: [:environment] do
    options = {}
    OptionParser.new(args) do |opts|
      opts.banner = 'Usage: rake locale:export [options]'
      opts.on('-l', '--locale {locale}','The locale to extract', String) do |locale|
        options[:locale] = locale
      end
    end.parse!

    locales = []
    locales = I18n.config.available_locales unless options[:locale]
    locales = I18n.config.available_locales.detect(options[:locale]).next_values if options[:locales]

    locales.map(&:to_s).each do | locale |
      begin
        locale_config = YAML.load_file("config/locales/#{locale}.yml")
        Rails.logger.info locale_config.inspect
      rescue Errno::ENOENT
        locale_config = {}
        locale_config[locale] = {}
      end

      records = TranslationKey.joins(:translations).where(translation_texts: {locale: locale})
      records.each do | record |
        # puts "#{record.key}= #{record.translations.first.text}"
        find_or_create_hash(locale_config[locale], record.key.split('.'), record.translations.first.text)
      end

      File.open("config/locales/#{locale}.yml", 'w') {|f| f.write locale_config.to_yaml }
    end
  end

  desc 'Import the locale from YAML to the database'
  task :import do
    options = {}
    OptionParser.new(args) do |opts|
      opts.banner = 'Usage: rake locale:export [options]'
      opts.on('-l', '--locale {locale}','The locale to extract', String) do |locale|
        options[:locale] = locale
      end
    end.parse!


  end
end
