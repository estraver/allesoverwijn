require 'optparse'
require 'ya2yaml'

namespace :locale do |args|
  ARGV.shift
  ARGV.shift

  def find_or_create_hash(config, arr, value)
    key = arr.shift
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

  def find_or_create_key(hash, locale, key = [])
    hash.each_pair do |k,v|
      key.push(k)
      if v.is_a? Hash
        find_or_create_key v, locale, key
      else
        puts "key: #{key.join('.')}= #{v}"
        tk = TranslationKey.find_or_create_by(key: key.join('.'))
        if v.is_a?(Array)
          tk.translations.find_or_create_by(locale: locale).text = v.to_yaml
        else
          tk.translations.find_or_create_by(locale: locale).text = v
        end

        tk.save!
      end

      key.pop

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
  task import: [:environment] do
    options = {}
    options[:locale] = []
    options[:lang] = ''

    OptionParser.new(args) do |opts|
      opts.banner = 'Usage: rake locale:import [options]'
      opts.on('-f', '--file {locale}','The locale to import') do |locale|
        options[:locale] << locale
      end
      opts.on('-l', '--lang {language}', I18n.config.available_locales.join(','), "The language to import (#{I18n.config.available_locales})") do |lang|
        options[:lang] = lang
      end
      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end.parse!

    options[:locale].map(&:to_s).each do | locale |
      begin
        locale_config = YAML.load_file("config/locales/#{locale}.yml")
      rescue Errno::ENOENT
        puts "Error: no such file config/locales/#{locale}.yml"
        exit
      end

      puts "Import file: #{locale} for language #{options[:lang]}"
      find_or_create_key locale_config[options[:lang]], options[:lang]
    end

    exit 0
  end
end
