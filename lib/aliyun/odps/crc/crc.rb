require 'rbconfig'

module Aliyun
  module Odps
    class CrcCalculator
      # @param [StringIO] data
      # @return crc32c to_i
      def self.calculate(data)
        if !$USE_FAST_CRC
          require_relative 'origin/crc32c'
          crc32c = Digest::CRC32c.new
          crc32c.update(data.string)
          return crc32c.checksum.to_i
        elsif getOsType == 'linux' || getOsType == 'unix'
          require_relative 'lib/odps/linux/crc32c.so'
          return Crc32c.calculate(data.string, data.length, 0).to_i
        elsif getOsType == 'windows'
          require_relative 'lib/odps/win/crc32c.so'
          return Crc32c.calculate(data.string, data.length, 0).to_i
        end
      end

      def self.getOsType
        host_os = RbConfig::CONFIG['host_os']
        case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          'windows'
        when /linux/
          'linux'
        when /solaris|bsd/
          'unix'
        else
          fail Error::WebDriverError, 'unspport os'
        end
      end
    end
  end
end
