require 'aliyun/odps/client/clients'
require 'aliyun/odps/http'

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
      #
      # ilowzBTRmVJb5CUr
      # IlWd7Jcsls43DQjX5OXyemmRf1HyPN
      def initialize(access_key, secret_key, options = {})
        @access_key = access_key
        @secret_key = secret_key
        @options = options

        @services = {}
      end

      %w(get put post delete options head).each do |method|
        define_method(method) do |*args|
          http.send(method, *args)
        end
      end

      private

      def http
        @http ||= Http.new(access_key, secret_key, @options[:endpoint])
      end
    end
  end
end
