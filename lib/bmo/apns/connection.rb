# encoding: utf-8
module BMO
  module APNS
    # Handle the connection state SSL or Pure TCP
    class Connection
      attr_reader :host, :port, :cert_path, :cert_pass

      def initialize(host, port, cert_path = nil, cert_pass = nil)
        @host      = host
        @port      = port
        @cert_path = cert_path
        @cert_pass = cert_pass
      end

      # Create a connection to Apple. If a cert_path exists it uses SSL else
      #   a pure TCPSocket. It then yields the socket and handles the closing
      #
      def connect(&block)
        socket = cert_path ? ssl_socket : tcp_socket
        socket.connect

        yield socket

        socket.close
      end

      private

      # @return [TCPSocket]
      def tcp_socket
        TCPSocket.new(host, port)
      end

      # @return [SSLSocket] the SSLSocket setted to sync_close
      #   to sync tcp and ssl closing
      def ssl_socket
        ssl_socket = OpenSSL::SSL::SSLSocket.new(tcp_socket, ssl_context)
        ssl_socket.sync_close = true
        ssl_socket
      end

      # @return [SSLContext] SSLContext setted with the certificate
      #
      def ssl_context
        cert         = File.read(cert_path)
        context      = OpenSSL::SSL::SSLContext.new
        context.cert = OpenSSL::X509::Certificate.new(cert)
        context.key  = OpenSSL::PKey::RSA.new(cert, cert_pass)
        context
      end
    end # class Connection
  end # module APNS
end # module BMO
