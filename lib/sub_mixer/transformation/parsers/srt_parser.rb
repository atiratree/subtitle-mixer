require 'srt'
require 'loofah'


module SubMixer
  module SRTParser
    class << self

      def parse(content)
        lines = SRT::File.parse(content).lines

        lines = lines.reject do |sub|
          sub.error
        end.sort_by do |sub|
          [sub.start_time, sub.end_time]
        end

        result = lines.map do |line|
          # remove html tags
          text = Loofah.fragment(line.text.join("\n"))
                     .scrub!(:strip)
                     .text
                     .strip
          metadata = {}

          if line.display_coordinates
            metadata[:display_coordinates] = line.display_coordinates
          end

          SubMixer::Utils.is_empty(text) ? nil :
              SubMixer::Subtitle.new(
                  {
                      :text => text,
                      :start_time => line.start_time,
                      :end_time => line.end_time,
                      :metadata => metadata,
                  }
              )
        end.select do |sub|
          sub
        end

        return result, {}
      end

      def compose(subtitles)
        lines = subtitles.subtitles.each_with_index.map do |sub, idx|
          line = SRT::Line.new
          # Add space coz of bug in 'srt', '~> 0.1.3'
          line.display_coordinates = " #{sub.metadata[:display_coordinates]}"
          line.sequence = idx + 1
          line.start_time = sub.start_time
          line.end_time = sub.end_time
          line.text = sub.text.split("\n")
          line
        end
        srt_file = SRT::File.new
        srt_file.lines = lines
        srt_file.to_s
      end
    end
  end
end
