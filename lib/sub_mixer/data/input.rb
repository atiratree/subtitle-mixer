module SubMixer
  class Input

    attr_accessor :filename
    attr_accessor :name
    attr_accessor :content

    attr_accessor :subtitles
    attr_accessor :priority_generator


    def initialize(filename:nil, name:nil, content:nil, priority_generator:nil)
      @filename = filename
      @name = name
      @content = content
      @priority_generator = priority_generator
    end
  end
end
