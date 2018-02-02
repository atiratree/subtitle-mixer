module SubMixer
  module Import
    class << self
      def import(content,id, name, format)
        parser = nil
        case format
        when :srt
          parser = SubMixer::SRTParser.new
        when :ssa, :ass
          parser = SubMixer::ASSParser.new
        else
          fail SubMixer::FormatError "Format #{format.to_s.upcase} not supported for #{name}"
        end

        result = parser.parse(id, name, content)
        parser.report.each { |line| SubMixer.logger.warn line }
        parser.reset

        result
      rescue SubMixer::FormatError => e
        raise e
      rescue
        raise "Failure while importing #{format.to_s.upcase} from #{name}"
      end
    end
  end
end
