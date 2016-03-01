module BMO
  module APNS
    # The Notification Class handles all the packaging logic
    class Notification
      # Define ==
      include Equalizer.new(:device_token, :payload)

      attr_reader :device_token, :payload

      def initialize(device_token, payload, options = {})
        @device_token = DeviceToken.new(device_token)
        @payload      = Payload.new(payload, options)
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

      # The Payload contains the data sent to Apple
      class Payload
        class PayloadTooLarge < Exception; end

        MAX_BYTE_SIZE = 2048

        # Define ==
        include Equalizer.new(:data)

        attr_reader :data, :truncable_field, :options

        def initialize(data, options = {})
          @data            = data
          @truncable_field = options[:truncable_field]
          @options         = options
        end

        def to_package
          truncate_field! if truncable_field && !valid?
          validate!
          package
        end

        def validate!
          return true if valid?
          str = "Payload byte size (#{package.bytesize})" \
            " should be less than #{Payload::MAX_BYTE_SIZE} bytes"
          fail PayloadTooLarge, str
        end

        def package
          data.to_json.bytes.to_a.pack('C*')
        end

        def truncate_field!
          return unless data[:aps] && data[:aps][truncable_field]
          string                = data[:aps][truncable_field]
          diff_bytesize         = package.bytesize - MAX_BYTE_SIZE
          desirable_bytesize    = (string.bytesize - diff_bytesize) - 1
          data[:aps][truncable_field] = Utils
            .bytesize_force_truncate(string, desirable_bytesize, options)
        end

        def valid?
          package.bytesize < MAX_BYTE_SIZE
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
            fail(MalformedDeviceToken, "Malformed Device Token : #{token}")
          end
          true
        end
      end # class DeviceToken
    end # class Notification
  end # module APNS
end # module BMO
