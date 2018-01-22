require 'srt'

module SubMixer
  class BasicGenerator

    def initialize(priority)
      @priority = priority
    end

    def process(subtitles)
      subtitles.subtitles.each do |sub|
        sub.priority =  @priority
        sub.priority_flag = :default
      end
    end
  end
end
