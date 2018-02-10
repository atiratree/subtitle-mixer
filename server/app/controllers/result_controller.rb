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

  WORD_LIST_NAME='wordsName'
  WORD_LIST_CONTENT='wordsContent'
  WORD_LIST_PERCENTAGE_THRESHOLD='wordsPercentageThreshold'
  WORD_LIST_CONSIDER_BELOW_THRESHOLD='considerBelowThreshold'

  FORMAT='format'
  SUB_2_PERCENTAGE='sub2Percentage'
  PERSIST_FORMATTING='persistFormatting'

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

    sub_output = SubMixer::Output.new(name: 'combined',
                                      format: format,
                                      persist_formatting: output[PERSIST_FORMATTING],
                                      max_parallel_sub_drift: 0.2)
    puts output[PERSIST_FORMATTING]
    sub_inputs, word_list_input = to_inputs(data[SUB_1], data[SUB_2],
                                            output[SUB_2_PERCENTAGE].to_f)
    runner = SubMixer::Runner.new(sub_inputs, sub_output,
                                  word_list_input: word_list_input,
                                  fail_hard: true)

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
        return [to_lang_input(sub1, 100 - sub2_percentage),
                to_lang_input(sub2, sub2_percentage)], nil
      else
        return [to_lang_input(sub1, 1)], to_study_input(sub2)
      end
    else
      if sub2[MODE] == LANG_MODE
        return [to_lang_input(sub2, 1)], to_study_input(sub1)
      else
        fail 'both subtitles can\'t have study mode'
      end
    end
  end

  def to_lang_input(sub, percentage)
    name = sub[NAME]
    SubMixer::Input.new(name: sub[NAME],
                        content: decode_sub(sub[CONTENT], name),
                        weight_generator: SubMixer::PercentageGenerator.new(percentage))
  end

  def to_study_input(sub)
    name = sub[NAME]
    words_name = sub[WORD_LIST_NAME]

    weight_generator = SubMixer::DictionaryWeightGenerator.new(
        sub[WORD_LIST_PERCENTAGE_THRESHOLD],
        !sub[WORD_LIST_CONSIDER_BELOW_THRESHOLD])

    SubMixer::WordListSubtitleInput.new(name: name,
                                        content: decode_sub(sub[CONTENT], name),
                                        weight_generator: weight_generator,
                                        word_list_name: words_name,
                                        word_list_content: decode_text(sub[WORD_LIST_CONTENT], words_name))
  end

  DATA_URI_REGEX = /\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/m

  def decode_sub(base64_uri, name)
    decode(base64_uri)
  rescue
    raise "#{name} is not a valid format. Should be one of: #{SubMixer::SubUtils.supported_formats.join(', ')}."
  end

  def decode_text(base64_uri, name)
    decode(base64_uri)
  rescue
    raise "#{name} is not a valid text format."
  end

  def decode(base64_uri)
    puts base64_uri
    data_uri_parts = base64_uri.match(DATA_URI_REGEX)
    Base64.decode64(data_uri_parts[2])
  end

  def encode(content)
    "data:text/plain;base64,#{Base64.strict_encode64(content)}"
  end

end
