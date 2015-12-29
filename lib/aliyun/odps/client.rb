require 'aliyun/odps/http'
require 'aliyun/odps/service_object'

module Aliyun
  module Odps
    class Client < ServiceObject
      extend Aliyun::Odps::Modelable

      include Singleton

      has_many :projects #no actions through client

      attr_reader :access_key, :secret_key, :opts

      # Initialize a object
      #
      # @param access_key [String] access_key obtained from aliyun
      # @param secret_key [String] secret_key obtained from aliyun
      # @option opts [String] :endpoint endpoint for API
      #
      # @return [Response]
      def initialize
        @access_key = Aliyun::Odps.config.access_key
        @secret_key = Aliyun::Odps.config.secret_key
        @opts = Aliyun::Odps.config.options
        @services = {}
      end

      %w(get put post delete options head).each do |method|
        define_method(method) do |*args|
          http.send(method, *args)
        end
      end

      private

      def http
        @http ||= Http.new(access_key, secret_key)
      end
    end
  end
end
