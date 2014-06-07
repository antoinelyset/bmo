<img src="https://raw.github.com/antoinelyset/bmo/master/bmo.png"
     alt="BMO"
     align="right"
     width="150px"/>

<br>
<br>
<br>

# BMO (Beemo)

BMO is a gem to Push Notifications to iOS (via APNS) and Android (via GCM)

| Project                 |  BMO                                                                                                                          |
|------------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| Gem Name                |  bmo                                                                                                                          |
| License                 |  [MIT](https://github.com/antoinelyset/bmo/blob/master/LICENSE)                                                               |
| Version                 |  [![Gem Version](https://badge.fury.io/rb/bmo.png)](http://badge.fury.io/rb/bmo)                                              |
| Dependency Status       |  [![Dependency Status](https://gemnasium.com/antoinelyset/bmo.png)](https://gemnasium.com/antoinelyset/bmo)                   |
| Continuous Integration  |  [![Build Status](https://secure.travis-ci.org/antoinelyset/bmo.png?branch=master)](https://travis-ci.org/antoinelyset/bmo)   |
| Quality Metric          |  [![Code Climate](https://codeclimate.com/github/antoinelyset/bmo.png)](https://codeclimate.com/github/antoinelyset/bmo)  |
| Test Coverage           |  [![Coverage Status](https://coveralls.io/repos/antoinelyset/bmo/badge.png)](https://coveralls.io/r/antoinelyset/bmo)         |
| Homepage                |  [BMO](https://github.com/antoinelyset/bmo)                                                                                   |
| Documentation           |  [Rdoc](http://rdoc.info/github/antoinelyset/bmo/frames)                                                                      |

## Installation

```
gem install bmo
```

In Gemfile :

```
gem 'bmo'
```

## APNS

### Usage

```ruby
token = "123456789" # The device token given to you by Apple
data  = {aps: {alert: "Hello from BMO!"}}
BMO.send_ios_notification(token, data)
```

The aps Hash content's is described here :

[https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/ApplePushService.html](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/ApplePushService.html)

### Configuration

Default Params :

```ruby
BMO.configuration do |config|
  config.apns.gateway_host  = 'gateway.push.apple.com'
  config.apns.gateway_port  = 2195
  config.apns.feedback_host = 'feedback.push.apple.com'
  config.apns.feedback_port = 2196
  config.apns.cert_path     = nil
  config.apns.cert_pass     = nil
end
```

If you set a cert_path option it will use a SSL encapsulation otherwise it will use Pure TCP.
This option is particularly useful if you use a stunnel.

## GCM

### Usage

```ruby
token = "123456789" # The device token given to you by Apple
data  = {message: "Hello from BMO!"}
BMO.send_android_notification(token, data)
```

The data content's is described here :

[http://developer.android.com/google/gcm/server.html](http://developer.android.com/google/gcm/server.html)

### Configuration

Default Params :

```ruby
BMO.configuration do |config|
  config.gcm.gateway_url  = 'https://android.googleapis.com/gcm/send'
  config.gcm.api_key      = nil
end
```

You should set the api_key. It uses Faraday internally, so just set your regular http_proxy environment variable if need to configure a proxy.

## License

BMO is released under the [MIT
License](http://www.opensource.org/licenses/MIT)
