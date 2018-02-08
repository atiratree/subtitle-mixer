# frozen_string_literal: true
require 'json'
require 'sub_mixer'
require 'base64'

class ResultController < ApplicationController
  layout 'result'

  DATA='data'

  SUB_1='sub1'
  SUB_2='sub2'
  OUTPUT='output'
  NAME='name'
  CONTENT='content'
  MODE='mode'

  FORMAT='format'
  SUB_2_PERCENTAGE='sub2Percentage'

  STUDY_MODE='STUDY'
  LANG_MODE='LANG'

  R_NAME = 'name'
  R_BASE_64_CONTENT = 'base64Content'
  R_REPORT = 'report'
  R_ERROR = 'error'

  def mix
    @props = {
        R_NAME => nil,
        R_BASE_64_CONTENT => nil,
        R_REPORT => [],
        R_ERROR => nil,
    }

    data = JSON.parse(params[DATA])

    output = data[OUTPUT]
    format = output[FORMAT].downcase == 'ass' ? :ass : :srt

    sub_output = SubMixer::Output.new(filename: 'combined', # just a name, is not saved
                                      format: format,
                                      persist_formatting: false,
                                      max_parallel_sub_drift: 0.2)

    sub_inputs = to_inputs(data[SUB_1], data[SUB_2], output[SUB_2_PERCENTAGE].to_f)
    runner = SubMixer::Runner.new(sub_inputs, sub_output, fail_hard: true)

    @props[R_NAME], content = runner.mix_only
    @props[R_BASE_64_CONTENT] = encode(content)
    @props[R_REPORT] = runner.report
  rescue Exception => e
    @props[R_ERROR] = e.message
    SubMixer.logger.error e
  end

  private

  def to_inputs(sub1, sub2, sub2_percentage)
    if sub1[MODE] == LANG_MODE
      if sub2[MODE] == LANG_MODE

        sub1_weight = (100 - sub2_percentage) / 100.to_f
        sub2_weight = sub2_percentage / 100.to_f
        [to_lang_input(sub1, sub1_weight),
         to_lang_input(sub2, sub2_weight)]
      else
        [to_lang_input(sub1, 1),
         to_study_input(sub2)]
      end
    else
      if sub2[MODE] == LANG_MODE
        [to_study_input(sub1),
         to_lang_input(sub2, 1)]
      else
        fail 'both subtitles can\'t have study mode'
      end
    end
  end

  def to_lang_input(sub, weight)
    name = sub[NAME]
    SubMixer::Input.new(name: sub[NAME],
                        content: decode(sub[CONTENT], name),
                        weight_generator: SubMixer::WeightGenerator.new(weight))
  end

  def to_study_input(sub)
    fail 'Not implemented yet!'
  end

  DATA_URI_REGEX = /\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/m

  def decode(base64_uri, name)
    puts base64_uri
    data_uri_parts = base64_uri.match(DATA_URI_REGEX)
    Base64.decode64(data_uri_parts[2])
  rescue
    raise "#{name} is not a valid format. Should be one of: #{SubMixer::SubUtils.supported_formats.join(', ')}."
  end

  def encode(content)
    "data:text/plain;base64,#{Base64.strict_encode64(content)}"
  end
end
