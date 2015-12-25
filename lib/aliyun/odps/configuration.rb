module Aliyun
  module Odps
    class Configuration
      attr_accessor :access_key, :secret_key, :endpoint, :options
      def initialize
        @options = {}
      end
    end
  end
end
