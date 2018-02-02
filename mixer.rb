#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'dotenv/load'
require 'sub_mixer'


def run
  is_debug = true
  is_verbose = true
  persist_formatting = true
  font_size = 45

  set_logging is_debug, is_verbose

  s1 = ENV['S1']
  s2 = ENV['S2']

  words_file = ENV['DICTIONARY']
  output_filename = ENV['OUT']

  words = SubMixer::FileUtils.read words_file

  inputs = [
      SubMixer::Input.new(filename: s1, priority_generator: SubMixer::BasicPriorityGenerator.new(1)),
      SubMixer::Input.new(filename: s2, priority_generator: SubMixer::BasicPriorityGenerator.new(1)),
      # SubMixer::Input.new(filename: s2, priority_generator: SubMixer::DictionaryPriorityGenerator.new(words, 100, true)),
  ]

  output = SubMixer::Output.new(filename: output_filename,
                                format: :ass,
                                persist_formatting: persist_formatting,
                                font_size: font_size)

  SubMixer::Runner.new(inputs, output)
      .run
rescue Exception => e
  SubMixer.logger.error is_debug ? e : e.message
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
