module SubMixer
  class Runner
    def initialize(inputs, output_filename, output_format)
      @inputs = inputs
      @output_filename = output_filename
      @output_format = output_format
    end

    def run
      content_inputs = inputs_to_contents @inputs
      subs = content_inputs_to_subs content_inputs
      mix_and_export subs
    end

    private

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
        SubMixer.logger.info "Removing duplicate #{input.name ? input.name : input.filename}"
      end
      content_inputs
    end

    def content_inputs_to_subs(inputs)
      inputs.map do |input|
        format = SubMixer::SubUtils.detect_format(input.content)
        subs = SubMixer::Import.import(input.content, input.name, format)

        if subs.subtitles.size > 0
          SubMixer.logger.info "Mixing #{input.name} (detected #{format}) with #{input.priority_generator.class.name}"
        else
          SubMixer.logger.info "Skipping #{input.name} because empty"
        end

        input.priority_generator.process subs
        subs
      end.select { |item| item.subtitles.size > 0 }
    end

    def mix_and_export(subs)
      mixer = SubMixer::Mixer.new subs

      result_subs = mixer.mix
      result_subs.name = @output_filename
      result_subs.format = @output_format

      mixer.report.each do |k, v|
        SubMixer.logger.info "Picked #{v} subtitles from #{subs[k].name}"
      end


      result_content = SubMixer::Export.export(result_subs)
      filename = SubMixer::FileUtils.write(result_content,
                                           @output_filename,
                                           @output_format)
      SubMixer.logger.info "Mixed subtitles exported to #{filename}"
    end
  end
end
