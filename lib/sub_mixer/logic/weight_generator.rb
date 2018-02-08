module SubMixer
  class WeightGenerator
    def initialize(weight)
      fail 'weight must be between 0 and 1' if (!weight.is_a? Numeric) || weight < 0 || weight > 1
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
      fail 'priority must be integer larger than 0' if (!priority.is_a? Integer) || priority < 1
      @weight = 1 / priority.to_f
    end
  end
end
