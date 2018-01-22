module SubMixer
  module SubUtils
    class << self

      def supported_formats
        [:srt, :ssa, :ass]
      end

      def detect_format(string)
        # matches ssa/ass
        captures = string.match(/\[Script Info\].*ScriptType:\s*v(?<version>[0-9\.]+)(?<plus>\+?)/m)
        if captures
          version = captures[:version].to_f
          is_plus = captures[:plus] == '+'

          if (version == 4.0 && is_plus) || version > 4.0
            :ass
          else
            :ssa
          end
        else
          # matches srt
          if string.match(/[^[[:space:]]]+ -+> [^[[:space:]]]+ ?(X1:\d+ X2:\d+ Y1:\d+ Y2:\d+)?/m)
            :srt
          else
            raise 'Unknown format'
          end
        end
      end
    end
  end
end
