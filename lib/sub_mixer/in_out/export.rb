module SubMixer
  module Export
    class << self
      def export(subtitles, output)
        composer = nil
        case subtitles.format
        when :srt
          composer = SubMixer::SRTComposer.new
        when :ssa, :ass
          composer = SubMixer::ASSComposer.new
        else
          fail SubMixer::FormatError "Export format #{subtitles.format.to_s.upcase} not supported for #{subtitles.name}"
        end
        result = composer.compose subtitles, output
        composer.report.each { |line| SubMixer.logger.info line }
        composer.reset
        result
      rescue SubMixer::FormatError => e
        raise e
      rescue
        raise "Failed composing content for #{subtitles.format.to_s.upcase}"
      end
    end
  end
end
