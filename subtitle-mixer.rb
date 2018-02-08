#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'sub_mixer'

def run
  options = SubMixer::ArgParser.parse
  set_logging options[:debug], options[:verbose]
  runner = SubMixer::Runner.new(options[:inputs],
                                options[:output],
                                word_list_input: options[:word_list_input],
                                fail_hard: options[:fail_hard])
  runner.run
rescue SystemExit
  exit # on --help
rescue Exception => e
  SubMixer.logger.error (options && options[:debug]) ? e : e.message
  exit 1
end

def set_logging(is_debug, is_verbose)
  log_severity= is_debug ? Logger::DEBUG : (is_verbose ? Logger::INFO : Logger::WARN)

  formatter = proc do |severity, datetime, progname, msg|
    "#{severity}: #{msg}\n"
  end

  SubMixer.logger = Logger.new($stdout, level: log_severity, formatter: formatter)
end

run
