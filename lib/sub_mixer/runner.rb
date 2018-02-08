module SubMixer
  class Runner
    attr_accessor :report

    def initialize(inputs, output, word_list_input: nil, fail_hard: false)
      @inputs = inputs
      @output = output
      @word_list_input = word_list_input
      @fail_hard = fail_hard
      @report = []
    end

    def run
      filename, result_content = mix_only
      to_file filename, result_content
    end

    def mix_only
      inputs = with_word_list(@inputs, @word_list_input)
      content_inputs = inputs_to_contents inputs
      subs = content_inputs_to_subs content_inputs
      mix_and_export subs
    end

    private

    def with_word_list(inputs, word_list_input)
      if word_list_input
        if word_list_input.word_list_filename
          word_list_input.words = SubMixer::FileUtils.read word_list_input.word_list_filename
        end
        unless word_list_input.name
          word_list_input.name = word_list_input.word_list_filename
        end
        word_list_input.words = SubMixer::FileUtils.as_safe_string(word_list_input.words, word_list_input.name)
        word_list_input.weight_generator.set_words(word_list_input.words)
        inputs + [word_list_input]
      else
        inputs
      end
    end

    def inputs_to_contents(inputs)
      file_inputs = inputs.select { |input| input.filename }
                        .uniq { |input| input.filename }

      content_inputs = inputs.select { |input| input.content }

      file_inputs.each do |input|
        input.content = SubMixer::FileUtils.read(input.filename)
        unless input.name
          input.name = input.filename
        end
      end
      content_inputs += file_inputs

      content_inputs.each do |input|
        input.content = SubMixer::FileUtils.as_safe_string(input.content, input.name)
      end

      content_inputs.uniq! { |input| input.content }
      (inputs - content_inputs).each do |input|
        name = input.name ? input.name : input.filename
        if SubMixer::Utils.is_empty(input.content)
          SubMixer.logger.info "Removing empty file #{name}"
          fail "Empty file #{name}" if @fail_hard
        else
          SubMixer.logger.info "Removing duplicate #{name}"
          fail "Duplicate file #{name}" if @fail_hard
        end
      end
      content_inputs
    end

    def content_inputs_to_subs(inputs)
      inputs.map.with_index do |input, idx|
        begin
          format = SubMixer::SubUtils.detect_format(input.content)
        rescue
          should_be = "Should be one of: #{SubMixer::SubUtils.supported_formats.join(', ')}."
          SubMixer.logger.info "Invalid format: skipping #{input.name}. #{should_be}"
          fail "#{input.name} has invalid format. #{should_be}" if @fail_hard
          return
        end
        subs = SubMixer::Import.import(input.content, idx, input.name, format)

        if subs.subtitles.size > 0
          SubMixer.logger.info "Mixing #{input.name} (detected #{format}) with #{input.weight_generator.class.name}"
        else
          SubMixer.logger.info "Skipping #{input.name} because empty"
          fail "No subtitles found in #{name}" if @fail_hard
        end

        input.weight_generator.process subs
        subs
      end.select { |item| item && item.subtitles.size > 0 }
    end

    def mix_and_export(subs)
      if @output.max_parallel_sub_drift
        mixer = SubMixer::Mixer.new subs, max_parallel_sub_drift: @output.max_parallel_sub_drift
      else
        mixer = SubMixer::Mixer.new subs # gets default drift
      end

      result_subs = mixer.mix
      result_subs.name = @output.filename
      result_subs.format = @output.format

      mixer.report.each do |k, v|
        message = "Picked #{v} subtitles from #{subs[k].name}"
        SubMixer.logger.info message
        @report << message
      end

      name = SubMixer::FileUtils.with_extension(@output.filename, @output.format)
      content = SubMixer::Export.export(result_subs, @output)
      return name, content
    end

    def to_file(filename, result_content)
      filename = SubMixer::FileUtils.write(result_content, filename)
      SubMixer.logger.info "Mixed subtitles exported to #{filename}"
    end
  end
end
