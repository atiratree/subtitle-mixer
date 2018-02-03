require 'srt'

module SubMixer
  class WeightGenerator
    def initialize(weight)
      raise 'weight must be between 0 and 1' if (!priority.is_a? Numeric) || weight < 0 || weight > 1
      @weight = weight
    end

    def process(subtitles)
      subtitles.subtitles.each do |sub|
        sub.weight = @weight
        sub.pick_flag = :default
      end
    end
  end

  # Params:
  # +priority+:: subtitles are weighted with 1 / priority, higher priority number has less chance to be picked
  class PriorityGenerator < WeightGenerator
    def initialize(priority)
      raise 'priority must be integer larger than 0' if (!priority.is_a? Integer) || priority < 1
      @weight = 1 / priority.to_f
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

        sub.weight = count == 0 ? 0 : intersect_count / count.to_f

        if sub.weight >= @p
          sub.pick_flag = :pick_first
        elsif @drop_bellow_threshold
          sub.pick_flag = :drop
        else
          sub.pick_flag = :default
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
