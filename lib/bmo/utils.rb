# encoding: utf-8
module BMO
  # Utility module
  module Utils
    # Coerce string hash keys to symbols
    def self.coerce_to_symbols(hash)
      hash_symbolized = {}
      hash.each_pair do |key, value|
        key = key.to_sym if key.respond_to?(:to_sym)
        hash_symbolized[key] = value
      end
      hash_symbolized
    end
  end
end
