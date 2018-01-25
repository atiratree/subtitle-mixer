module SubMixer
  class Mixer
    attr_accessor :report

    def initialize(subs, subtitle_picker:nil, max_parallel_sub_drift:0.20)
      unless subs.kind_of?(Array)
        raise 'subs must be an array'
      end
      @subs = subs
      @sub_picker = subtitle_picker ? subtitle_picker : SubMixer::SubPicker.new
      @max_parallel_sub_drift = max_parallel_sub_drift
    end

    def mix
      result = SubMixer::Subtitles.new

      next_subs = {}
      time = 0


      @report = {}
      @subs.each_index { |idx| @report[idx] = 0 }

      loop do
        @subs.each_with_index do |sub, idx|
          # refresh next subs based on current time
          unless next_subs[idx]
            n = sub.get_next time
            if n
              next_subs[idx] = n
            else
              next_subs.delete idx
            end
          end
        end

        # there are no subs left after current time
        if next_subs.size == 0
          break;
        end

        # pick the earliest and other subs which are reasonably close
        new_start_time = next_subs.min_by { |k, v| v.start_time }[1].start_time
        considered_subs = next_subs.select do |k, v|
          v.start_time < new_start_time + @max_parallel_sub_drift
        end

        # choose sub
        chosen_sub_idx, chosen_sub = @sub_picker.pick_subtitle(considered_subs)
        result.subtitles << chosen_sub
        time = chosen_sub.end_time
        report[chosen_sub_idx] += 1


        # clear old subs
        next_subs.reject! { |k, v| v.start_time < time }
      end
      result
    end
  end
end
