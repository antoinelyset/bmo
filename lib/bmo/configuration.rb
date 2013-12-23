# encoding: utf-8
# Main BMO module
module BMO
  # Handles all the configuration per provider
  class Configuration
    attr_reader :apns, :gcm

    def initialize
      @apns = APNS.new
      @gcm  = GCM.new
    end

    # APNS Configuration
    #
    # @!attribute gateway_host
    # @!attribute gateway_port
    # @!attribute feedback_host
    # @!attribute feedback_port
    # @!attribute cert_path
    # @!attribute cert_pass
    class APNS
      attr_accessor :cert_path,     :cert_pass,
                    :gateway_host,  :gateway_port,
                    :feedback_host, :feedback_port

      def initialize
        @gateway_host  = 'gateway.push.apple.com'
        @gateway_port  = 2195
        @feedback_host = 'feedback.push.apple.com'
        @feedback_port = 2196
        @cert_path     = nil
        @cert_pass     = nil
      end
    end

    # GCM Configuration
    class GCM
      attr_accessor :gateway_url, :api_key
      def initialize
        @gateway_url = 'https://android.googleapis.com/gcm/send'
        @api_key     = nil
      end
    end
  end # class Configuration

  def self.configure
    yield(configuration) if block_given?
    configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end
end # BMO
