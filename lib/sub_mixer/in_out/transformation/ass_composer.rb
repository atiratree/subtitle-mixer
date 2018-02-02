require 'set'

module SubMixer
  class ASSComposer < Composer
    include SubMixer::ASSConstants

    def reset
      super
      @metadatas = Set.new
      @events = ''
      @result = ''
    end

    def compose(subtitles, output)
      subtitles.subtitles.each do |subtitle|
        metadata = subtitle.metadata[:ass_metadata]
        ssa_ass = metadata != nil && output.persist_formatting

        style_suffix = ''
        values = nil

        if ssa_ass
          values = metadata[:values]
          global_metadata = metadata[:global_metadata]
          style_suffix = get_suffix global_metadata
          @metadatas << global_metadata
        end

        event_fields = [
            '0',
            compose_timestamp(subtitle.start_time),
            compose_timestamp(subtitle.end_time),
            ssa_ass ? (values[STYLE_FIELD] + style_suffix) : 'Default',
            ssa_ass ? values[NAME_FIELD] : '',
            '0000',
            '0000',
            '0000',
            '',
            ssa_ass ? values[TEXT_FIELD] : subtitle.text.gsub("\n", '\N')
        ]

        @events << "Dialogue: #{event_fields.join(',')}\n"
      end

      playres_x, playres_y = get_play_res

      create_line(SCRIPT_INFO)
      create_pair(SCRIPT_TYPE, 'v4.00+')
      create_pair(PLAY_RES_X, playres_x)
      create_pair(PLAY_RES_Y, playres_y)
      finish_block

      create_line(V4P_STYLES)
      create_pair(FORMAT, STYLE_FIELDS.join(', '))
      create_styles output.font_size
      finish_block

      create_line(EVENTS)
      create_pair(FORMAT, EVENT_FIELDS.join(', '))
      create_events

      @result
    end

    private

    def get_play_res
      m = @metadatas.map do |metadata|
        metadata[:script_info]
      end.max_by do |metadata|
        metadata[PLAY_RES_X].to_i * metadata[PLAY_RES_Y].to_i
      end
      x = m ? m[PLAY_RES_X] : 0
      y = m ? m[PLAY_RES_Y] : 0
      if x == 0 || y == 0
        x = DEFAULT_PLAYRES_X
        y = DEFAULT_PLAYRES_Y
        @report << 'No resolution found'
      end
      @report << "Setting resolution to #{x}x#{y}"

      return x, y
    end

    def create_line(line)
      @result << "#{line}\n"
    end

    def create_pair(key, value)
      @result << "#{key}:#{value}\n"
    end

    def finish_block
      @result << "\n"
    end

    def create_events
      @result << @events
    end

    def create_styles(font_size)
      style_result = get_default_style(font_size) # for subs without style (usually srt)
      @metadatas.each do |metadata|
        styles = metadata[:v4_styles][:styles]
        format = metadata[:format]
        style_suffix = get_suffix metadata

        styles.each do |style|
          name_value = style[NAME_FIELD] + style_suffix
          # skip first name field
          style_values = STYLE_FIELDS.drop(1).map do |field|
            get_style_field_value(style[field], field, format, font_size)
          end
          style_result << "Style: #{name_value},#{style_values.join(',') }\n"
        end
      end

      @result << style_result
    end

    def get_suffix(metadata)
      "-sub#{metadata[:id]}"
    end

    def compose_timestamp(seconds)
      format('%01d:%02d:%02d.%s',
             seconds / 3600,
             (seconds % 3600) / 60,
             seconds % 60,
             format('%.2f', seconds)[-2, 3])
    end
  end
end
