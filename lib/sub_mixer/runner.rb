module SubMixer
  class Runner
    def initialize(inputs, output, word_list_input: nil)
      @inputs = inputs
      @output = output
      @word_list_input = word_list_input
    end

    def run
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
      content_inputs.uniq! { |input| input.content }
      (inputs - content_inputs).each do |input|
        name = input.name ? input.name : input.filename
        if SubMixer::Utils.is_empty(input.content)
          SubMixer.logger.info "Removing empty file #{name}"
        else
          SubMixer.logger.info "Removing duplicate #{name}"
        end
      end
      content_inputs
    end

    def content_inputs_to_subs(inputs)
      inputs.map.with_index do |input, idx|
        format = SubMixer::SubUtils.detect_format(input.content)
        subs = SubMixer::Import.import(input.content, idx, input.name, format)

        if subs.subtitles.size > 0
          SubMixer.logger.info "Mixing #{input.name} (detected #{format}) with #{input.weight_generator.class.name}"
        else
          SubMixer.logger.info "Skipping #{input.name} because empty"
        end

        input.weight_generator.process subs
        subs
      end.select { |item| item.subtitles.size > 0 }
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
        SubMixer.logger.info "Picked #{v} subtitles from #{subs[k].name}"
      end


      result_content = SubMixer::Export.export(result_subs,
                                               @output)
      filename = SubMixer::FileUtils.write(result_content,
                                           @output.filename,
                                           @output.format)
      SubMixer.logger.info "Mixed subtitles exported to #{filename}"
    end
  end
end
