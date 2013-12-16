# encoding: utf-8
module BMO
  module APNS
    # The Client Class handles the connection to Apple
    #
    class Client
      attr_reader :cert_path,     :cert_pass,
                  :gateway_host,  :gateway_port,
                  :feedback_host, :feedback_port

      # The constructor of the Client object
      #   it will only use a ssl connection if you pass a cert_path option
      #
      # @param gateway_host  [String]
      # @param gateway_port  [Integer]
      # @param feedback_host [String]
      # @param feedback_port [Integer]
      #
      # @options options [String] :cert_pass
      # @options options [String] :cert_path path to certificate file
      #
      def initialize(gateway_host, gateway_port,
                     feedback_host, feedback_port,
                     options = {})
        @gateway_host  = gateway_host
        @gateway_port  = gateway_port
        @feedback_host = feedback_host
        @feedback_port = feedback_port
        @cert_path     = options[:cert_path]
        @cert_pass     = options[:cert_pass]
      end

      # @param notification [Notification] the notification to send to Apple
      #
      def send_notification(notification)
        connection = BMO::APNS::Connection.new(@gateway_host, @gateway_port,
                                               @cert_path, @cert_pass)
        connection.connect do |socket|
          socket.write(notification.to_package)
        end
      end

      # Get the Feedback from Apple
      #
      def get_feedback
        connection = BMO::APNS::Connection.new(@feedback_host, @feedback_port,
                                               @cert_path, @cert_pass)
        connection.connect do |socket|
          socket.read
        end
      end

      private

      def default_options
        {
          cert_path:     nil,
          cert_pass:     nil,
          gateway_host:  'gateway.push.apple.com',
          gateway_port:  2195,
          feedback_host: 'feedback.push.apple.com',
          feedback_port: 2196
        }
      end
    end # class Client
  end # module APNS
end # module BMO
