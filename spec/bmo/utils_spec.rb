# encoding: UTF-8
require 'spec_helper'

describe BMO::Utils do
  describe '#bytesize_force_truncate' do

    it 'truncates the string' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', 10, omission: ''))
        .to eq('Ça a déb')
    end

    it 'adds a default omission' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', 10))
        .to eq('Ça a d...')
    end

    it 'adds accepts an optional omission params' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', 10, omission: '[more]'))
        .to eq('Ça [more]')
    end

    it 'forces the returned string to be less or equal to the length' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', 10, omission: '[more]').bytesize)
        .to be 10
    end

    it 'does not mutate the string' do
      string = 'Ça a débuté comme ça.'
      BMO::Utils.bytesize_force_truncate(string, 10)
      expect(string.bytesize)
        .to be > 10
    end

    it 'returns an empty string if the length if less than 1' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', -2))
        .to eq('')
    end

    it 'returns the whole string if the length is more than the string length' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', 100000))
        .to eq('Ça a débuté comme ça.')
    end

    it 'accepts a separator param' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', 20, separator: ' '))
        .to eq('Ça a débuté...')
    end

    it 'returns an empty string if the length if less than 1' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', -2))
        .to eq('')
    end

    it 'truncates the omission too' do
      expect(BMO::Utils.bytesize_force_truncate('Ça a débuté comme ça.', 2))
        .to eq('..')
    end
  end
end
