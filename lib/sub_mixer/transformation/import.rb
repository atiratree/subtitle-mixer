module SubMixer
  module Import
    class << self

      def import(content, name, format)
        result = SubMixer::Subtitles.new(name, format)
        case format
        when :srt
          result.subtitles, result.metadata = SubMixer::SRTParser.parse(content)
        else
          fail SubMixer::FormatError "Format #{format.to_s.upcase} not supported for #{name}"
        end

        result
      rescue SubMixer::FormatError => e
        raise e
      rescue
        raise "Failure while importing #{format.to_s.upcase} from #{name}"
      end
    end
  end
end
