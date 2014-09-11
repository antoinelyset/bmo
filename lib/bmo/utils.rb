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

    # Byte aware truncation
    def self.bytesize_force_truncate(string, bytesize, options = {})
      if bytesize <= 0
        return ''
      elsif bytesize > string.bytesize
        return string.dup
      end

      options[:omission] ||= '...'
      computed_bytesize = bytesize - options[:omission].bytesize
      return bytesize_force_truncate(options[:omission],
                                     bytesize,
                                     omission: '') if computed_bytesize <= 0
      new_string = ''

      string.chars.each_with_index do |char, i|
        break if (new_string + char).bytesize > computed_bytesize
        new_string << char
      end

      stop =  if options[:separator]
                new_string.rindex(options[:separator]) || new_string.length
              else
                new_string.length
              end
      (new_string[0...stop] + options[:omission]).to_s
    end
  end
end
