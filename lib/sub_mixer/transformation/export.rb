
module SubMixer
  module Export
    class << self

      def export(subtitles)
        case subtitles.format
        when :srt
          SubMixer::SRTParser.compose subtitles
        else
          fail SubMixer::FormatError "Export format #{subtitles.format.to_s.upcase} not supported"
        end
      rescue SubMixer::FormatError => e
        raise e
      rescue
        raise "Failed composing content for #{subtitles.format.to_s}"
      end
    end
  end
end
