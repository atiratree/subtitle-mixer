require 'srt'

module SubMixer
  class SRTComposer < Composer
    def compose(subtitles, output)
      lines = subtitles.subtitles.each_with_index.map do |sub, idx|
        metadata = sub.metadata[:srt_metadata]
        if metadata
          if metadata[:display_coordinates]
            # Add space coz of bug in 'srt', '~> 0.1.3'
            line.display_coordinates = " #{metadata[:display_coordinates]}"
          end
          text = output.persist_formatting ? metadata[:dirty_text] : sub.text
        else
          text = sub.text
        end
        line = SRT::Line.new
        line.sequence = idx + 1
        line.start_time = sub.start_time
        line.end_time = sub.end_time
        line.text = text.split("\n")
        line
      end
      srt_file = SRT::File.new
      srt_file.lines = lines
      srt_file.to_s
    end
  end
end
