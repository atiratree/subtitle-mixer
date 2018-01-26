require 'srt'
require 'nokogiri'

module SubMixer
  class SRTParser < Parser
    def initialize
      super
      @format = :srt
    end

    def parse(id, name, content)
      result = SubMixer::Subtitles.new(name: name, format: @format)
      parsed_lines = SRT::File.parse(content).lines

      lines = parsed_lines.reject do |sub|
        sub.error
      end.sort_by do |sub|
        [sub.start_time, sub.end_time]
      end

      skipped_subs = parsed_lines.length - lines.length
      if skipped_subs > 0
        @report << "#{name} skipped #{skipped_subs} badly formatted subtitles"
      end

      lines.each do |line|
        return unless line.start_time < line.end_time

        dirty_text = line.text.join("\n")
        # remove html tags
        text = Nokogiri::HTML(dirty_text)
                   .xpath('//text()')
                   .text
                   .strip

        return if text.empty?

        srt_metadata = {
            :dirty_text => dirty_text
        }

        if line.display_coordinates
          srt_metadata[:display_coordinates] = line.display_coordinates
        end

        result.subtitles << SubMixer::Subtitle.new(
            {
                :text => text,
                :start_time => line.start_time,
                :end_time => line.end_time,
                :metadata => {
                    :srt_metadata => srt_metadata
                },
            }
        )
      end
      result
    end
  end
end
