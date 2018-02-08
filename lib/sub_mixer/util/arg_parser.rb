require 'optparse'

module SubMixer
  module ArgParser
    def self.parse
      inputs = []
      output = SubMixer::Output.new(format: :ass,
                                    persist_formatting: false,
                                    max_parallel_sub_drift: 0.2)

      options = {
          :word_list_input => nil,
          :inputs => inputs,
          :output => output,
          :debug => false,
          :verbose => false,
      }

      OptionParser.new do |opts|
        opts.banner = 'Usage: subtitle-mixer.rb [options]'

        opts.on('-p', '--psubtitle FILENAME,[PERCENTAGE]', Array,
                'Subtitles are picked based on weight = (PERCENTAGE / 100).',
                'There is no check that percentages add to 100. ',
                'So subs can have together 150%. You can use priority in --rsubtitle instead',
                "\tFILENAME file with subtitles in \"srt\" or \"ass\" format",
                "\tPERCENTAGE only accurate when all the subtitles add to 100",
                "\tDEFAULT VALUES: PERCENTAGE=100",
                "\t* this option can be specified multiple times",
                "\n") do |args|
          percentage = 100

          case args.length
          when 0, 1
            check_empty args
          when 2
            percentage = as_percentage(args[1], 'PERCENTAGE')
          else
            fail OptionParser::NeedlessArgument.new('Too many arguments')
          end
          filename = args[0]
          inputs << SubMixer::Input.new(filename: filename, weight_generator: SubMixer::PercentageGenerator.new(percentage))
        end

        opts.on do |args|
          puts args
        end

        opts.on('-r', '--rsubtitle FILENAME,[PRIORITY]', Array,
                'Subtitles are picked based on weight = (1 / PRIORITY).',
                "\tFILENAME file with subtitles in \"srt\" or \"ass\" format",
                "\tPRIORITY higher PRIORITY number has less chance to be picked;",
                "\t\t chance difference to be picked between priorities 1:2 is much larger than between 999:1000",
                "\tDEFAULT VALUES: PRIORITY=1",
                "\t* this option can be specified multiple times",
                "\n") do |args|
          priority = 1

          case args.length
          when 0, 1
            check_empty args
          when 2
            priority = as_int(args[1], 'PRIORITY', true)
          else
            fail OptionParser::NeedlessArgument.new('Too many arguments')
          end
          filename = args[0]
          inputs << SubMixer::Input.new(filename: filename, weight_generator: SubMixer::PriorityGenerator.new(priority))
        end

        opts.on('-w', '--wsubtitle FILENAME,WORDLIST_FILENAME,[PERCENTAGE_THRESHOLD],[DROP_BELLOW_THRESHOLD]', Array,
                'Subtitles are picked based upon known words in each sentence from WORDLIST_FILENAME',
                "\tFILENAME file with subtitles in \"srt\" or \"ass\" format",
                "\tWORDLIST_FILENAME file which contains known words",
                "\tPERCENTAGE_THRESHOLD how many percent of each sentence should be covered by known words",
                "\t\tfor the sentence to be picked",
                "\tDROP_BELLOW_THRESHOLD true,false; if true, than each sentence will be weighed by the percentage of",
                "\t\trecognized words until reaching PERCENTAGE_THRESHOLD",
                "\tDEFAULT VALUES: PERCENTAGE_THRESHOLD=100, DROP_BELLOW_THRESHOLD=FALSE",
                "\t* this option can be specified only once",
                "\n") do |args|
          percentage_threshold = 100
          drop_bellow_threshold = false

          if options[:word_list_input]
            fail OptionParser::AmbiguousArgument.new('There can be only one specified')
          end

          case args.length
          when 0, 1
            check_empty args
            fail OptionParser::MissingArgument.new('WORDLIST_FILENAME')
          when 2
          when 3, 4
            percentage_threshold = as_percentage(args[2], 'PERCENTAGE_THRESHOLD')
            if 4
              drop_bellow_threshold = as_bool(args[3], 'DROP_BELLOW_THRESHOLD')
            end
          else
            fail OptionParser::NeedlessArgument.new('Too many arguments')
          end
          filename = args[0]
          word_list = args[1]
          dictionary_generator = SubMixer::DictionaryWeightGenerator.new(percentage_threshold, drop_bellow_threshold)
          options[:word_list_input] = SubMixer::WordListSubtitleInput.new(filename: filename,
                                                                          dictionary_generator: dictionary_generator,
                                                                          word_list_filename: word_list)
        end

        opts.on('-o', '--output FILENAME', OptionParser::REQUIRED_ARGUMENT) do |filename|
          output.filename = filename
        end

        opts.on('-f', '--format FORMAT', 'Format of output FILENAME. Supported formats: srt, ass',
                "\tDEFAULT VALUES: FORMAT=ass",) do |format|
          output.format = as_sub_format format, 'output'
        end

        opts.on('-u', '--persist-formatting', 'Tries to persist styles for srt/ssa. Can have variable outcomes. ',
                "\tSet output format the same as input format for best result") do |persist|
          output.persist_formatting = persist
        end

        opts.on('-s', '--font-size FONT_SIZE', Integer, 'Overrides FONT_SIZE for ass format') do |size|
          output.font_size = as_int size, 'FONT_SIZE', true
        end

        opts.on('-m', '--max-drift DRIFT', Float, 'Maximum time drift (in sec) between input subtitles. ',
                "\tThe subtitles will be considered to occur at the same time and picked by their weights.",
                "\t0 drift means subtitles must start at the exact same time to be considered for picking",
                "\tDEFAULT VALUES: DRIFT=0.2",) do |drift|
          if drift < 0
            fail OptionParser::InvalidArgument.new('DRIFT must be positive')
          end
          output.max_parallel_sub_drift = drift
        end


        opts.on('-d', '--debug') do |d|
          options[:debug] = d
        end

        opts.on('-v', '--verbose') do |v|
          options[:verbose] = v
        end

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          fail SystemExit
        end
      end.parse!

      input_count = inputs.length
      if options[:word_list_input]
        input_count += 1
      end

      if input_count < 2
        fail OptionParser::MissingArgument.new('at least 2 subtitles (i.e. --psubtitle, --rsubtitle or --wsubtitle) must be specified. See -h for help')
      end

      unless output.filename
        fail OptionParser::MissingArgument.new('--output FILENAME. See -h for help')
      end
      puts options
      options
    end

    private

    # Array type eats also other options
    def self.check_empty(args)
      len = args.length
      if len == 0 || (len == 1 && (args[0][0] == '-')) # no filename or caught other option
        fail OptionParser::MissingArgument.new('FILENAME')
      end
    end

    def self.as_int(value, name, positive=false)
      result = Integer(value)
      if positive && result < 1
        fail OptionParser::InvalidArgument.new("#{name} must be larger than 0")
      end
      result
    rescue
      fail OptionParser::InvalidArgument.new("#{name} must be integer")
    end

    def self.as_percentage(value, name)
      result = as_int(value, name)
      if result < 0 || result > 100
        fail OptionParser::InvalidArgument.new("#{name} should be Integer between 0 and 100")
      end
      result
    end

    def self.as_bool(value, name)
      case value.downcase
      when 'true'
        true
      when 'false'
        false
      else
        fail OptionParser::InvalidArgument.new("#{name} must be either \"true\" or \"false\"")
      end
    end

    def self.as_sub_format(value, name)
      case value.downcase
      when 'srt'
        :srt
      when 'ass'
        :ass
      else
        fail OptionParser::InvalidArgument.new("#{name} format is not supported, must be either \"srt\" or \"ass\"")
      end
    end
  end
end
