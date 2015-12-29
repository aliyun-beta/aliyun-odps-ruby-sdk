require 'aliyun/odps/http'
require 'aliyun/odps/service_object'

module Aliyun
  module Odps
    class Client < ServiceObject
      extend Aliyun::Odps::Modelable

      has_many :projects

      attr_reader :access_key, :secret_key, :endpoint, :opts

      # Initialize a object
      #
      # @param access_key [String] access_key obtained from aliyun
      # @param secret_key [String] secret_key obtained from aliyun
      # @option opts [String] :endpoint endpoint for API
      #
      # @return [Response]
      def initialize(config = Aliyun::Odps.config)
        @access_key = config.access_key
        @secret_key = config.secret_key
        @endpoint = config.endpoint
        @opts = config.options
      end

      %w(get put post delete options head).each do |method|
        define_method(method) do |*args|
          http.send(method, *args)
        end
      end

      private

      def http
        @http ||= Http.new(access_key, secret_key, endpoint)
      end
    end
  end
end
