module SubMixer
  module SubUtils
    class << self

      def supported_formats
        [:srt, :ssa, :ass]
      end

      def detect_ssa_or_ass(version)
        version = version.strip
        captures = version.match(/v(?<version>[0-9\.]+)(?<plus>\+?)/)
        if captures
          version = captures[:version].to_f
          is_plus = captures[:plus] == '+'

          if (version == 4.0 && is_plus) || version > 4.0
            :ass
          else
            :ssa
          end
        else
          raise 'Unknown format'
        end
      end

      def detect_format(string)
        # matches srt
        if string.match(/[^[[:space:]]]+ -+> [^[[:space:]]]+ ?(X1:\d+ X2:\d+ Y1:\d+ Y2:\d+)?/m)
          :srt
        else
          # matches ssa/ass
          captures = string.match(/\[Script Info\].*ScriptType:\s*(?<version>[^\n]+)\s*\n/m)
          if captures
            detect_ssa_or_ass captures[:version]
          else
            raise 'Unknown format'
          end
        end
      end
    end
  end
end
