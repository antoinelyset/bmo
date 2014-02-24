# encoding: utf-8
module BMO
  module APNS
    # The Notification Class handles all the packaging logic
    class Notification
      # Define ==
      include Equalizer.new(:device_token, :payload)

      attr_reader :device_token, :payload

      def initialize(device_token, payload)
        @device_token = DeviceToken.new(device_token)
        @payload      = Payload.new(payload)
      end

      def to_package
        payload_packaged      = payload.to_package
        device_token_packaged = device_token.to_package
        [
          0, 0,
          device_token_packaged.size,
          device_token_packaged,
          0,
          payload_packaged.size,
          payload_packaged
        ].pack('ccca*cca*')
      end

      def validate!
        device_token.validate!
        payload.validate!
      end

      private

      # The Payload contains the data sent to Apple
      class Payload
        class PayloadTooLarge < Exception; end

        MAX_BYTE_SIZE = 256

        # Define ==
        include Equalizer.new(:data)

        attr_reader :data

        def initialize(data)
          @data = Utils.coerce_to_symbols(data)
        end

        def to_package
          data.to_json.bytes.to_a.pack('C*')
        end

        def validate!
          if to_package.size > MAX_BYTE_SIZE
            str = <<-EOS
              Payload size should be less than #{Payload::MAX_BYTE_SIZE} bytes
            EOS
            fail PayloadTooLarge, str
          end
          true
        end
      end # class Payload

      # The DeviceToken is the id of a Device for an App
      class DeviceToken
        # Define ==
        include Equalizer.new(:token)

        class MalformedDeviceToken < Exception; end

        attr_reader :token

        def initialize(token)
          @token = token
        end

        def to_package
          [token].pack('H*')
        end

        def validate!
          unless token =~ /^[a-z0-9]{64}$/i
            fail(MalformedDeviceToken, 'Malformed Device Token')
          end
          true
        end
      end # class DeviceToken
    end # class Notification
  end # module APNS
end # module BMO
