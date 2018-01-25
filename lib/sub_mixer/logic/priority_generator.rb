require 'srt'

module SubMixer
  class BasicPriorityGenerator

    def initialize(priority)
      @priority = priority
    end

    def process(subtitles)
      subtitles.subtitles.each do |sub|
        sub.priority = @priority
        sub.priority_flag = :default
      end
    end
  end

  class DictionaryPriorityGenerator

    def initialize(words, percentage_threshold, drop_bellow_threshold=true)
      if percentage_threshold < 0 || percentage_threshold > 100
        fail ArgumentError('pecentage should be between 0 and 100')
      end

      @p = percentage_threshold / 100.to_f
      @drop_bellow_threshold = drop_bellow_threshold
      @dictionary = create_dictionary(words)

    end

    def process(subtitles)
      subtitles.subtitles.each do |sub|
        sub_dictionary = create_dictionary(sub.text)
        count = sub_dictionary.size
        intersect_count = (@dictionary & sub_dictionary).size

        sub.priority = count == 0 ? 0 : intersect_count / count.to_f

        if sub.priority >= @p
          sub.priority_flag = :pick_first
        elsif @drop_bellow_threshold
          sub.priority_flag = :drop
        else
          sub.priority_flag = :default
        end
      end
    end

    private

    def create_dictionary(words)
      dict = Set.new
      words.downcase
          .split(/\P{L}/) # any non word character
          .reject { |word| word == '' }
          .each { |word| dict.add word }
      dict
    end
  end
end
