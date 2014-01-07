# encoding: utf-8

require 'socket'
require 'openssl'
require 'json'
require 'equalizer'
require 'faraday'

require 'bmo/version'
require 'bmo/configuration'
require 'bmo/utils'

require 'bmo/apns/notification'
require 'bmo/apns/connection'
require 'bmo/apns/client'

require 'bmo/gcm/notification'
require 'bmo/gcm/connection'
require 'bmo/gcm/client'

# Main BMO namespace
module BMO
  # All the methods will be Class Methods
  module_function

  # Send ios notification with the configuration of BMO
  #   (see #BMO::Configuration)
  #
  # @param device_token [String]
  # @param data [Hash] The data you want to send
  #
  # @return The Socket#write return
  #
  # @see https://developer.apple.com/library/ios/documentation/
  #   NetworkingInternet/Conceptual/RemoteNotificationsPG/
  #   Chapters/ApplePushService.html
  def send_ios_notification(device_token, data)
    notification = APNS::Notification.new(device_token, data)
    apns_client.send_notification(notification)
  end

  # Get the iOS Feedback tuples
  #
  # @return [Array<FeedbackTuple>] Feedback Object containing
  #   a time and a token
  def get_ios_feedback
    apns_client.get_feedback
  end

  # Send android notification with the configuration of BMO
  #   (see #BMO::Configuration)
  #
  # @param device_token [String]
  # @param data [Hash] The data you want to send
  #
  # @return [Faraday::Response] The HTTP Response
  #
  # @see http://developer.android.com/google/gcm/server.html]
  def send_android_notification(device_token, data)
    notification = GCM::Notification.new(device_token, data)
    android_client.send_notification(notification)
  end

  private

  def apns_client
    conf   = BMO.configuration.apns
    APNS::Client.new(conf.gateway_host,
                     conf.gateway_port,
                     conf.feedback_host,
                     conf.feedback_port,
                     cert_path: conf.cert_path,
                     cert_pass: conf.cert_pass)
  end

  def gcm_client
    conf   = BMO.configuration.gcm
    GCM::Client.new(conf.gateway_url,
                    conf.api_key)
  end
end
