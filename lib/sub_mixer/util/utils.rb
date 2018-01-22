module SubMixer
  module Utils
    class << self

      def is_empty(val)
        not val or val.empty?
      end
    end
  end
end
