# encoding: utf-8

require 'socket'
require 'openssl'
require 'json'
require 'equalizer'

require 'bmo/version'
require 'bmo/configuration'

require 'bmo/apns/notification'
require 'bmo/apns/connection'
require 'bmo/apns/client'

# Main BMO namespace
module BMO
  def self.send_ios_notification(device_token, data)
    conf   = BMO.configuration.apns
    client = APNS::Client.new(conf.gateway_host,
                              conf.gateway_port,
                              conf.feedback_host,
                              conf.feedback_port,
                              cert_path: conf.cert_path,
                              cert_pass: conf.cert_pass)

    notification = APNS::Notification.new(device_token, data)
    client.send_notification(notification)
  end
end
