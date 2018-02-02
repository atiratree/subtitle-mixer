require 'set'

module SubMixer
  module ASSConstants
    SCRIPT_INFO='[Script Info]'
    V4P_STYLES='[V4+ Styles]'
    SUPPORTED_STYLES_LCASE_HEADERS = Set.new(['[v4 styles]', '[v4+ styles]', '[v4 styles+]'])
    EVENTS='[Events]'

    SCRIPT_TYPE='ScriptType'
    TIMER='Timer'
    PLAY_RES_X='PlayResX'
    PLAY_RES_Y='PlayResY'

    FORMAT='Format'

    STYLE='Style'

    FONT_NAME_FIELD='Fontname'
    FONT_SIZE_FIELD='Fontsize'
    PRIMARY_COLOUR_FIELD='PrimaryColour'
    SECONDARY_COLOUR_FIELD='SecondaryColour'
    OUTLINE_COLOUR_FIELD='OutlineColour'
    BACK_COLOUR_FIELD='BackColour'
    BOLD_FIELD='Bold'
    ITALIC_FIELD='Italic'
    UNDERLINE_FIELD='Underline'
    STRIKEOUT_FIELD='StrikeOut'
    SCALE_X_FIELD='ScaleX'
    SCALE_Y_FIELD='ScaleY'
    SPACING_FIELD='Spacing'
    ANGLE_FIELD='Angle'
    BORDER_STYLE_FIELD='BorderStyle'
    OUTLINE_FIELD='Outline'
    SHADOW_FIELD='Shadow'
    ALIGNMENT_FIELD='Alignment'
    MARGIN_L_FIELD='MarginL'
    MARGIN_R_FIELD='MarginR'
    MARGIN_V_FIELD='MarginV'
    ENCODING_FIELD='Encoding'

    DIALOGUE='Dialogue'

    LAYER_FIELD='Layer'
    START_FIELD='Start'
    END_FIELD='End'
    STYLE_FIELD='Style'
    NAME_FIELD='Name'
    EFFECT_FIELD='Effect'
    TEXT_FIELD='Text'

    STYLE_FIELDS = [
        NAME_FIELD,
        FONT_NAME_FIELD,
        FONT_SIZE_FIELD,
        PRIMARY_COLOUR_FIELD,
        SECONDARY_COLOUR_FIELD,
        OUTLINE_COLOUR_FIELD,
        BACK_COLOUR_FIELD,
        BOLD_FIELD,
        ITALIC_FIELD,
        UNDERLINE_FIELD,
        STRIKEOUT_FIELD,
        SCALE_X_FIELD,
        SCALE_Y_FIELD,
        SPACING_FIELD,
        ANGLE_FIELD,
        BORDER_STYLE_FIELD,
        OUTLINE_FIELD,
        SHADOW_FIELD,
        ALIGNMENT_FIELD,
        MARGIN_L_FIELD,
        MARGIN_R_FIELD,
        MARGIN_V_FIELD,
        ENCODING_FIELD,
    ]

    EVENT_FIELDS = [
        LAYER_FIELD,
        START_FIELD,
        END_FIELD,
        STYLE_FIELD,
        NAME_FIELD,
        MARGIN_L_FIELD,
        MARGIN_R_FIELD,
        MARGIN_V_FIELD,
        EFFECT_FIELD,
        TEXT_FIELD,
    ]

    DEFAULT_PLAYRES_X = 1280
    DEFAULT_PLAYRES_Y = 720
    DEFAULT_FONT_SIZE = 50

    def get_default_style(font_size)
      "Style: Default,Arial,#{font_size ? font_size : DEFAULT_FONT_SIZE},&H00FFFFFF,&H00FFFFFF,&H40000000,&H40000000,0,0,0,0,100,100,0,0.00,1,3,0,2,20,20,20,1\n"
    end

    def get_style_field_value(value, field, format, font_size)
      is_empty = SubMixer::Utils.is_empty(value)

      if field == FONT_SIZE_FIELD
        if font_size
          font_size
        else
          is_empty ? DEFAULT_FONT_SIZE : value
        end
      elsif format == :ssa || is_empty
        # fill missing ssa fields with default values
        case field
        when ALIGNMENT_FIELD
          2
        when UNDERLINE_FIELD
          0
        when STRIKEOUT_FIELD
          0
        when SCALE_X_FIELD
          100
        when SCALE_Y_FIELD
          100
        when SPACING_FIELD
          0
        when ANGLE_FIELD
          0
        else
          is_empty ? '' : value
        end
      else
        value
      end
    end
  end
end
