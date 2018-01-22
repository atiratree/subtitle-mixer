module SubMixer
  class Subtitles
    attr_accessor :name
    attr_accessor :format
    attr_accessor :subtitles
    attr_accessor :metadata

    def initialize(name=nil, format=nil, subtitles=[], metadata={})
      @name = name
      @format = format
      @subtitles = subtitles
      @metadata = metadata

      @index = 0
    end

    def get_next(time)
      while @index < @subtitles.length
        if @subtitles[@index].start_time >= time
          return @subtitles[@index]
        end
        @index += 1
      end
      nil
    end
  end
end
