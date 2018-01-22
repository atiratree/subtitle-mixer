require 'charlock_holmes'

module SubMixer
  module FileUtils
    class << self

      def read(filename, encoding=nil)
        begin
          content = File.read(filename)
        rescue
          raise "Could not open #{filename}"
        end

        begin
          unless encoding
            detection = CharlockHolmes::EncodingDetector.detect(content)
            encoding = detection[:encoding]
          end
          SubMixer.logger.info "Assuming #{encoding} for #{filename}"
          content.force_encoding(encoding)
        rescue
          raise "Failure while setting encoding for #{filename}"
        end

        begin
          content.encode('UTF-8')
        rescue
          raise "Failure while transcoding #{filename} from #{content.encoding} to intermediate UTF-8 encoding"
        end
      end

      def write(content, path, extension)
        filename = with_extension(path, extension)
        begin
          File.open(filename, 'w:UTF-8') do |f|
            f.write content
          end
          filename
        rescue
          raise "Could not write to file #{filename}"
        end
      end

      private

      def with_extension(path, extension)
        path = path.strip
        match = path.match(/^.*\.#{extension}$/)
        match ? match[0] : "#{path}.#{extension}"
      end
    end
  end
end
