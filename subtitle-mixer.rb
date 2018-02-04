#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'sub_mixer'

def run
  options = SubMixer::ArgParser.parse
  set_logging options[:debug], options[:verbose]
  SubMixer::Runner.new(options[:inputs], options[:output], word_list_input: options[:word_list_input])
      .run
rescue SystemExit
  # program wants to exit: usually on --help
rescue Exception => e
  SubMixer.logger.error (options && options[:debug]) ? e : e.message
end

def set_logging(is_debug, is_verbose)
  # default logger is created as DEBUG
  unless is_debug
    log_severity= is_verbose ? Logger::INFO : Logger::WARN

    formatter = proc do |severity, datetime, progname, msg|
      "#{severity}: #{msg}\n"
    end

    SubMixer.logger = Logger.new($stdout, level: log_severity, formatter: formatter)
  end
end

run
