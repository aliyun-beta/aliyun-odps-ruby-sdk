require 'aliyun/odps/http'
require 'aliyun/odps/service_object'
require 'aliyun/odps/model/projects'

module Aliyun
  module Odps
    class Client < ServiceObject
      extend Aliyun::Odps::Modelable

      # @!method projects
      # @return [Projects]
      has_many :projects

      attr_reader :config

      # Initialize a object
      #
      # @param access_key [String] access_key obtained from aliyun
      # @param secret_key [String] secret_key obtained from aliyun
      # @option opts [String] :endpoint endpoint for API
      #
      # @return [Response]
      def initialize(config = Aliyun::Odps.config)
        @config = config
      end

      %w(get put post delete options head).each do |method|
        define_method(method) do |*args|
          http.send(method, *args)
        end
      end

      private

      def http
        @http ||= Http.new(config)
      end
    end
  end
end
