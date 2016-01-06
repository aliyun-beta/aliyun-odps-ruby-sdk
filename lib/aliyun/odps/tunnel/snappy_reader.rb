require 'zlib'
require 'odps_protobuf'

module Aliyun
  class SnappyReader
    def self.uncompress(data)
      load_snappy

      data.slice!(0, 18)
      Snappy.inflate(data)
    end

    def self.load_snappy
      require 'snappy'
    rescue LoadError
      raise 'Install snappy to support x-snappy-framed encoding: https://github.com/miyucy/snappy'
    end
  end
end
