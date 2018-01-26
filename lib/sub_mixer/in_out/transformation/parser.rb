module SubMixer
  class Parser
    attr_accessor :format
    attr_accessor :report

    def initialize
      reset
    end

    def reset
      @report = []
    end
  end
end
