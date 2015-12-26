require 'addressable/uri'

module Aliyun
  module Odps
    class Configuration
      attr_accessor :access_key, :secret_key, :endpoint, :options
      def initialize
        @options = {}
      end

      def protocol
        Addressable::URI.parse(@endpoint).scheme
      end
    end
  end
end
