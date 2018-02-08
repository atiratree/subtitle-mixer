require 'logger'

module SubMixer
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout, level: Logger::ERROR ).tap do |log|
        log.progname = self.name
      end
    end
  end
end
