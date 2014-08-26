# encoding: utf-8

require File.dirname(__FILE__) + '../../../spec_helper'

describe BMO::APNS::Notification::DeviceToken do
  describe '#validate!' do
    it 'returns true if the token is 64 chars' do
      device_token = described_class.new('a' * 64)
      expect(device_token.validate!).to be_true
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
      expect(device_token.to_package).to eq("\x00" * 32)
    end
  end
end

describe BMO::APNS::Notification::Payload do
  it 'coerce hash keys to symbols' do
    payload = described_class.new('Finn' => 'The Human')
    expect(payload.data).to eq(Finn: 'The Human')
  end

  it "doesn't coerce incompatible types" do
    payload = described_class.new(1 => 'For Money')
    expect(payload.data).to eq(1 => 'For Money')
  end

  it 'returns true for equality between coerced hash and symbolized hash ' do
    payload = described_class.new('Jake' => 'The Dog')
    expect(payload).to eq(described_class.new(Jake: 'The Dog'))
  end

  describe '#validate!' do
    it 'returns true if the payload is valid' do
      payload = described_class.new(apns: 'a' * 200)
      expect(payload.validate!).to be_true
    end
    it 'raises an error if the payload is too large' do
      payload = described_class.new(apns: 'a' * 256)
      expect { payload.validate! }.to raise_error(
        BMO::APNS::Notification::Payload::PayloadTooLarge)
    end
  end
end
