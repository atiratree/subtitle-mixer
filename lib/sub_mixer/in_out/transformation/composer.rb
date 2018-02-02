module SubMixer
  class Composer
    attr_accessor :report

    def initialize
      reset
    end

    def reset
      @report = []
    end
  end
end
