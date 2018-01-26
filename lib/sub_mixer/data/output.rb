module SubMixer
  class Output
    attr_accessor :filename
    attr_accessor :format
    attr_accessor :persist_formatting
    attr_accessor :font_size

    def initialize(filename:nil, format:nil, persist_formatting:false,font_size:nil)
      @filename = filename
      @format = format
      @persist_formatting = persist_formatting
      @font_size = font_size
    end
  end
end
