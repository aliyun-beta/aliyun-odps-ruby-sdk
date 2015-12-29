require 'base64'
require 'openssl'
require 'digest'
require 'gyoku'

module Aliyun
  module Odps
    class Utils
      class << self

        # Calculate content length
        #
        # @return [Integer]
        def content_size(content)
          if content.respond_to?(:size)
            content.size
          elsif content.is_a?(IO)
            content.stat.size
          end
        end

        # HexDigest body with MD5
        #
        # @return [String]
        def md5_hexdigest(body)
          Digest::MD5.hexdigest(body).strip
        end

        # @example
        #   # { 'a' => 1, 'c' => 3 }
        #   Utils.hash_slice({ 'a' => 1, 'b' => 2, 'c' => 3 }, 'a', 'c')
        #
        # @return [Hash]
        def hash_slice(hash, *selected_keys)
          new_hash = {}
          selected_keys.each { |k| new_hash[k] = hash[k] if hash.key?(k) }
          new_hash
        end

        # Convert File or Bin data to bin data
        #
        # @return [Bin data]
        def to_data(file_or_bin)
          file_or_bin.respond_to?(:read) ? IO.binread(file_or_bin) : file_or_bin
        end

        def to_xml(hash) # nodoc
          %(<?xml version="1.0" encoding="UTF-8"?>#{Gyoku.xml(hash)})
        end

        # Dig values in deep hash
        #
        # @example
        #   dig_value({ 'a' => { 'b' => { 'c' => 3 } } }, 'a', 'b', 'c')  # => 3
        #
        def dig_value(hash, *keys)
          new_hash = hash.dup

          keys.each do |key|
            if new_hash.is_a?(Hash) && new_hash.key?(key)
              new_hash = new_hash[key]
            else
              return nil
            end
          end
          new_hash
        end

        # @see {http://apidock.com/rails/String/underscore String#underscore}
        def underscore(str)
          word = str.to_s.dup
          word.gsub!(/::/, '/')
          word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
          word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
          word.tr!('-', '_')
          word.downcase!
          word
        end

        # Copy from {https://github.com/rails/rails/blob/14254d82a90b8aa4bd81f7eeebe33885bf83c378/activesupport/lib/active_support/core_ext/array/wrap.rb#L36 ActiveSupport::Array#wrap}
        def wrap(object)
          if object.nil?
            []
          elsif object.respond_to?(:to_ary)
            object.to_ary || [object]
          else
            [object]
          end
        end

        def stringify_keys!(hash)
          hash.keys.each do |key|
            hash[key.to_s] = hash.delete(key)
          end
        end

        def generate_uuid(flag)
          "#{flag}#{Time.now.strftime('%Y%m%d%H%M%S')}#{SecureRandom.hex(3)}"
        end
      end
    end
  end
end
