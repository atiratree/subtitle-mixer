module SubMixer
  class Subtitles
    attr_accessor :name
    attr_accessor :format
    attr_accessor :subtitles

    def initialize(name:nil, format:nil, subtitles:[])
      @name = name
      @format = format
      @subtitles = subtitles

      reset
    end

    def get_next(time)
      while @index < @subtitles.length
        curr_idx = @index
        @index += 1
        if @subtitles[curr_idx].start_time >= time
          return @subtitles[curr_idx]
        end
      end
      nil
    end

    def reset
      @index = 0
    end
  end
end
