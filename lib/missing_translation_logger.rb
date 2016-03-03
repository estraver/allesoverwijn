class MissingTranslationLogger
  def call(unfound)
    # Rails.logger.info 'app'
    # Rails.logger.info logger.inspect
    logger.warn "#{FastGettext.locale}: #{unfound}"
  end

  private

  def logger
    return @logger if @logger
    require 'logger'
    @logger = Logger.new('log/unfound_translations.log', 2, 5*(1024**2))#max 2x 5mb logfile
  end
end