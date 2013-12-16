# encoding: utf-8

require File.dirname(__FILE__) + '../../../spec_helper'

describe BMO::APNS::Notification::DeviceToken do
  describe '#token' do
    it 'returns the token' do
      device_token     = described_class.new('abc')
      expect(device_token.token).to eq('abc')
    end
  end

  describe '#==' do
    it 'returns true for equal device token' do
      device_token     = described_class.new('abc')
      device_token_bis = described_class.new('abc')
      expect(device_token == device_token_bis).to be_true
    end

    it 'returns true for equal device token' do
      device_token     = described_class.new('abc')
      device_token_bis = described_class.new('abc')
      expect(device_token).to eq(device_token_bis)
    end

    it 'returns false for equal device token' do
      device_token     = described_class.new('abc')
      device_token_bis = described_class.new('def')
      expect(device_token).to_not eq(device_token_bis)
    end

    it 'returns true for equal device token' do
      device_token     = described_class.new('abc')
      device_token_bis = described_class.new('def')
      expect(device_token == device_token_bis).to be_false
    end
  end

  describe '#validate!' do
    it 'returns true if the token is 64 chars' do
      device_token = described_class.new('a' * 64)
      expect(device_token.validate!).to be_true
    end

    it 'returns false if the token is not 64 chars' do
      device_token = described_class.new('a' * 63)
      expect { device_token.validate! }.to raise_error
        BMO::APNS::Notification::DeviceToken::MalformedDeviceToken
    end

    it 'returns false if the token contains a special char' do
      device_token = described_class.new(('a' * 63) + '"')
      expect { device_token.validate! }.to raise_error
        BMO::APNS::Notification::DeviceToken::MalformedDeviceToken
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
end
