module SubMixer
  class Input
    attr_accessor :filename
    attr_accessor :name
    attr_accessor :content

    attr_accessor :subtitles
    attr_accessor :weight_generator

    def initialize(filename: nil, name: nil, content: nil, weight_generator: nil)
      @filename = filename
      @name = name
      @content = content
      @weight_generator = weight_generator
    end
  end

  class WordListSubtitleInput < Input
    attr_accessor :word_list_filename
    attr_accessor :words

    def initialize(filename: nil, name: nil, content: nil, dictionary_generator: nil, word_list_filename: nil, words: nil)
      super(filename: filename, name: name, content: content, weight_generator: dictionary_generator)
      @word_list_filename = word_list_filename
      @words = words
    end
  end
end
