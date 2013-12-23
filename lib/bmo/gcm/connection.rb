# encoding: utf-8
module BMO
  module GCM
    # Handle the connection state SSL or Pure TCP
    #
    class Connection
      def initialize(gateway_url, api_key)
        @gateway_url = gateway_url
        @faraday_connection = Faraday::Connection.new(gateway_url)
        @api_key            = api_key
      end

      def connect(&block)
        faraday_connection.post(gateway_url) do |request|
          request.headers.merge!(content_type: 'application/json',
                                 authorization: "key=#{api_key}")
          yield request
        end
      end

      protected

      attr_reader :faraday_connection, :gateway_url, :api_key
    end # class Connection
  end # module GCM
end # module BMO
