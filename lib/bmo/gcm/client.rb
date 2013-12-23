# encoding: utf-8
module BMO
  module GCM
    # GCM Client Class
    class Client
      attr_reader :gateway_url, :api_key

      def initialize(gateway_url, api_key)
        @gateway_url = gateway_url
        @api_key     = api_key
      end

      # @param notification [Notification] the notification to send to Apple
      #
      def send_notification(notification)
        connection = GCM::Connection.new(gateway_url, api_key)
        connection.connect do |request|
          request.body = notification.to_package
        end
      end
    end # class Client
  end # module APNS
end # module BMO
