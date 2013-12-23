# encoding: utf-8
module BMO
  module APNS
    # APNS Client Class
    #
    # @!attribute gateway_host
    # @!attribute gateway_port
    # @!attribute feedback_host
    # @!attribute feedback_port
    # @!attribute cert_path
    # @!attribute cert_pass
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
      def initialize(gateway_host,  gateway_port,
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
        connection = APNS::Connection.new(@gateway_host, @gateway_port,
                                          @cert_path,    @cert_pass)
        connection.connect do |socket|
          socket.write(notification.to_package)
        end
      end

      # Get the Feedback from Apple
      #
      def get_feedback
        connection = APNS::Connection.new(@feedback_host, @feedback_port,
                                          @cert_path,     @cert_pass)
        connection.connect do |socket|
          socket.read
        end
      end
    end # class Client
  end # module APNS
end # module BMO
