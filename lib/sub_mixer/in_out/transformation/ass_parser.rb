require 'csv'
require 'nokogiri'

module SubMixer
  class ASSParser < Parser
    include SubMixer::ASSConstants

    def reset
      super
      @mode = nil
      @current_metadata = nil
      @current_format = nil
      @timer = 1
      @global_metadata = {
          :script_info => {},
          :v4_styles => {
              :styles => [],
          },
          :events => {},
          :id => nil,
          :format => nil,
      }
      @result = SubMixer::Subtitles.new
    end

    def parse(id, name, content)
      raise 'id must be number' unless id.is_a? Numeric

      @global_metadata[:id] = id
      @result.name = name

      content.each_line do |line|
        line.strip!

        if line.empty? || line[0] == ';' # ; is a comment
          next
        end

        # change mode
        if line[0] == '['
          old_mode = @mode
          @mode = parse_mode(line)
          if !old_mode && @mode != :script_info
            fail ParseError "#{SCRIPT_INFO} should be specified first"
          end
          @current_metadata = @global_metadata[@mode]
          @current_format = nil
          next
        end

        case @mode
        when :script_info
          parse_script_info(line)
        when :v4_styles, :events
          key, values = parse_format_section_line(line)
          case key
          when STYLE
            @current_metadata[:styles] << values
          when DIALOGUE
            add_subtitle(values)
          end
        end
      end

      @result.subtitles.sort_by! do |sub|
        [sub.start_time, sub.end_time]
      end
      @result
    rescue ParseError => e
      raise e
    rescue
      raise 'Could not parse invalid SSA/ASS file'
    end

    private

    def timer=(timer)
      t = Float(timer)
      if t > 0 && t != 100
        # we got useful timer
        @timer = t / 100.to_f
      end
    rescue
      @report << 'skipping invalid timer'
    end

    def current_format=(format)
      @current_metadata[:format] = format
      @current_format = format
    end

    def add_subtitle(values)
      start_time = parse_timestamp(values[START_FIELD]) * @timer
      end_time = parse_timestamp(values[END_FIELD]) * @timer

      # remove even subs with length == 0
      return unless start_time < end_time

      dirty_text = values[TEXT_FIELD]
      text = dirty_text.gsub(/{[^}]*}/, '').gsub(/\\N|\\n/, "\n")

      text = Nokogiri::HTML(text)
                 .xpath('//text()')
                 .text
                 .strip

      return if text.empty?

      @result.subtitles << SubMixer::Subtitle.new(
          {
              :text => text,
              :start_time => start_time,
              :end_time => end_time,
              :metadata => {
                  :ass_metadata => {
                      :global_metadata => @global_metadata,
                      :values => values
                  }
              },
          }
      )
    end

    def parse_mode(line)
      section = line.downcase
      if section == SCRIPT_INFO.downcase
        :script_info
      elsif SUPPORTED_STYLES_LCASE_HEADERS.include?(section)
        :v4_styles
      elsif section == EVENTS.downcase
        :events
      else
        @report << "Unsupported section #{section}"
        nil
      end
    end

    def parse_script_info(line)
      key, value = parse_pair line
      if key == SCRIPT_TYPE
        f = SubMixer::SubUtils.detect_ssa_or_ass value
        @result.format = f
        @global_metadata[:format] = f
      else
        @current_metadata[key] = value
        if key == TIMER
          self.timer = value
        end
      end
    end


    def parse_format_section_line(line)
      key, value = parse_pair line
      values = {}

      if !@current_format && key != FORMAT
        fail ParseError 'Format should be specified first in the section'
      end

      if key == FORMAT
        self.current_format = CSV.parse_line(value, :converters => lambda { |f| f.strip })
      else
        # split by commas and add to values
        field_max_index = @current_format.length - 1
        field_index = 0

        after_comma_index = 0
        value.each_char.with_index do |c, idx|
          if field_index == field_max_index
            # last field can have any character; even ','
            break
          end

          if c == ','
            values[@current_format[field_index]] = value[after_comma_index .. idx - 1]
            after_comma_index = idx + 1
            field_index += 1
          end
        end
        values[@current_format[field_index]] = value[after_comma_index .. value.length - 1]
      end
      return key, values
    end


    def parse_pair(line)
      if (separator = line.index(':'))
        return line[0 .. separator - 1].strip, line[separator + 1 .. line.length - 1].strip
      else
        return nil, nil
      end
    end

    def parse_timestamp(timestamp)
      m = timestamp.match(/\s*(?<h>\d):(?<m>\d{2}):(?<s>\d{2})[:|\.](?<ms>\d+)\s*/)
      m['h'].to_i * 3600 + m['m'].to_i * 60 + m['s'].to_i + "0.#{m['ms']}".to_f
    end
  end
end
