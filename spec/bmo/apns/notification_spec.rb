require_relative './../../spec_helper'

describe BMO::APNS::Notification::DeviceToken do
  describe '#validate!' do
    it 'returns true if the token is 64 chars' do
      device_token = described_class.new('a' * 64)
      expect(device_token.validate!).to be(true)
    end

    it 'raises an error if the token is not 64 chars' do
      device_token = described_class.new('a' * 63)
      expect { device_token.validate! }.to raise_error(
        BMO::APNS::Notification::DeviceToken::MalformedDeviceToken)
    end

    it 'raises an error if the token contains a special char' do
      device_token = described_class.new(('a' * 63) + '"')
      expect { device_token.validate! }.to raise_error(
        BMO::APNS::Notification::DeviceToken::MalformedDeviceToken)
    end
  end

  describe '#to_package' do
    it 'returns the packaged token' do
      device_token = described_class.new('0' * 64)
      expect(device_token.to_package).to eq("\x01\x00 " + "\x00" * 32)
    end
  end
end

describe BMO::APNS::Notification::Payload do
  let(:payload_max_size) { BMO::APNS::Notification::Payload::MAX_BYTE_SIZE }

  describe 'custom_data field' do
    it 'truncates if there is a truncable field and this is not valid' do
      payload = described_class.new(aps: { alert: 'a' }, custom_data: { hello: 'world' })
      expect(payload.to_package).to eq("\x02\x005{\"aps\":{\"alert\":\"a\"},\"custom_data\":{\"hello\":\"world\"}}")
    end
  end

  describe '#validate!' do
    it 'returns true if the payload is valid' do
      payload = described_class.new(aps: 'a' * 200)
      expect(payload.validate!).to be(true)
    end
    it 'raises an error if the payload is too large' do
      payload = described_class.new(aps: 'a' * payload_max_size)
      expect { payload.validate! }.to raise_error(
        BMO::APNS::Notification::Payload::PayloadTooLarge)
    end
  end

  describe '#to_package' do
    it 'truncates if there is a truncable field and this is not valid' do
      options = { truncable_alert: true }
      payload = described_class.new({ aps: { alert: 'a' * payload_max_size } }, options)
      # I'm not able to write the hex literal for the beginning
      expect(payload.to_package).to end_with("{\"aps\":{\"alert\":\"#{'a' * (payload_max_size - 27)}...\"}}")
    end

    it 'truncates to respect the MAX_BYTE_SIZE' do
      options = { truncable_alert: true }
      payload = described_class.new({ aps: { alert: 'a' * payload_max_size } }, options)
      expect(payload.to_package.bytesize).to be < BMO::APNS::Notification::Payload::MAX_BYTE_SIZE
    end
  end

  describe '#truncable_field!' do
    it 'truncates the corresponding field in aps' do
      options = { truncable_alert: true }
      payload = described_class.new({ aps: { alert: 'a' * payload_max_size } }, options)
      payload.truncate_alert!
      expect(payload.data[:aps][:alert]).to eq(('a' * (payload_max_size - 27)) + '...')
    end

    it 'truncates with omission' do
      options = { truncable_field: :true, omission: '[more]' }
      payload = described_class.new({ aps: { alert: 'a' * payload_max_size } }, options)
      payload.truncate_alert!
      expect(payload.data[:aps][:alert]).to eq(('a' * (payload_max_size - 30)) + '[more]')
    end

    it 'truncates with separator' do
      options = { truncable_field: true, separator: ' ' }
      payload = described_class.new({ aps: { alert: 'test ' + ('a' * (payload_max_size - 1)) } }, options)
      payload.truncate_alert!
      expect(payload.data[:aps][:alert]).to eq('test...')
    end
  end
end
