# encoding: utf-8
module BMO
  module GCM
    # The Notification Class handles all the packaging logic
    class Notification
      # Define ==
      include Equalizer.new(:device_token, :payload)

      attr_reader :device_token, :payload

      def initialize(device_token, payload)
        @device_token = device_token
        @payload      = Payload.new(payload)
      end

      def to_package
        {
          registration_ids: [device_token],
          data: payload.to_package
        }.to_json
      end

      def validate!
        payload.validate!
      end

      # The Payload contains the data sent to Apple
      class Payload
        # Error Raised when the payload packaged > MAX_BYTE_SIZE
        class PayloadTooLarge < Exception; end

        MAX_BYTE_SIZE = 4096

        # Define ==
        include Equalizer.new(:data)

        attr_reader :data

        def initialize(data)
          @data = Utils.coerce_to_symbols(data)
        end

        def to_package
          data
        end

        def validate!
          if to_package.bytesize > MAX_BYTE_SIZE
            str = <<-EOS
              Payload size should be less than #{Payload::MAX_BYTE_SIZE} bytes
            EOS
            fail PayloadTooLarge, str
          end
          true
        end
      end # class Payload
    end # class Notification
  end # module APNS
end # module BMO
