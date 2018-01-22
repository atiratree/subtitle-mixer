#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'dotenv/load'
require 'sub_mixer'


def run
  set_logging true, true

  s1 = ENV['S1']
  s2 = ENV['S2']
  output_filename = ENV['OUT']

  inputs = [
      SubMixer::Input.new(filename: s1, priority_generator: SubMixer::BasicGenerator.new(0.5)),
      SubMixer::Input.new(filename: s2, priority_generator: SubMixer::BasicGenerator.new(0.5)),
  ]

  SubMixer::Runner.new(inputs, output_filename, :srt)
      .run
rescue Exception => e
  SubMixer.logger.error e.message
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