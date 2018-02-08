module SubMixer
  class Output
    attr_accessor :filename
    attr_accessor :name
    attr_accessor :format
    attr_accessor :persist_formatting
    attr_accessor :font_size
    attr_accessor :max_parallel_sub_drift

    def initialize(filename: nil, name: nil, format: nil, persist_formatting: false, font_size: nil, max_parallel_sub_drift: nil)
      @filename = filename
      @name = name ? name : filename
      @format = format
      @persist_formatting = persist_formatting
      @font_size = font_size
      @max_parallel_sub_drift = max_parallel_sub_drift
    end
  end
end
