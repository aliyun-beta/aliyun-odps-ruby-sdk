require 'aliyun/oss/client/clients'
require 'aliyun/oss/http'

module Aliyun
  module Odps
    class Client
      attr_reader :access_key, :secret_key, :bucket

      # Initialize a object
      #
      # @param access_key [String] access_key obtained from aliyun
      # @param secret_key [String] secret_key obtained from aliyun
      # @option options [String] :host host for bucket's data center
      # @option options [String] :bucket Bucket name
      #
      # @return [Response]
      def initialize(access_key, secret_key, options = {})
        @access_key = access_key
        @secret_key = secret_key
        @options = options
        @bucket = options[:bucket]

        @services = {}
      end

      private

      def http
        @http ||= Http.new(access_key, secret_key, @options[:host])
      end
    end
  end
end
