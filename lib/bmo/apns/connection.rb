# encoding: utf-8
module BMO
  module APNS
    # Handle the connection state SSL or Pure TCP
    #
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
        if cert_path
          connect_with_ssl do |socket|
            yield socket
          end
        else
          connect_without_ssl do |socket|
            yield socket
          end
        end
      end

      private

      # Create a tcp and a ssl socket to the Apple Gateway,
      #   connect to the ssl and yield the SSL socket,
      #   it handles socket closing after yield
      #
      def connect_with_ssl(&block)
        ssl_socket, tcp_socket = ssl_connection
        ssl_socket.connect

        yield ssl_socket

        ssl_socket.close
        tcp_socket.close
      end

      # Create a pure TCPSocket and yield it,
      #   it handles socket closing after yield
      #
      def connect_without_ssl(&block)
        tcp_socket = tcp_connection

        yield tcp_socket

        tcp_socket.close
      end

      # @return [TCPSocket]
      def tcp_connection
        TCPSocket.new(host, port)
      end

      # @return [Array<SSLSocket, TCPSocket>] An array with first
      #   the SSLSocket you should write to then the TCPSocket.
      def ssl_connection
        tcp_socket = tcp_connection
        ssl_socket = OpenSSL::SSL::SSLSocket.new(tcp_socket, ssl_context)
        [ssl_socket, tcp_socket]
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
