require 'aliyun/odps/client/clients'
require 'aliyun/odps/http'

module Aliyun
  module Odps
    class Client
      attr_reader :access_key, :secret_key, :opts
      attr_accessor :current_project

      # Initialize a object
      #
      # @param access_key [String] access_key obtained from aliyun
      # @param secret_key [String] secret_key obtained from aliyun
      # @option opts [String] :endpoint endpoint for API
      # @option opts [String] :curr_project specify project name
      #
      # @return [Response]
      #
      # ilowzBTRmVJb5CUr
      # IlWd7Jcsls43DQjX5OXyemmRf1HyPN
      def initialize(access_key, secret_key, opts = {})
        @access_key = access_key
        @secret_key = secret_key
        @opts = opts
        @current_project = opts[:current_project] if opts.key?(:current_project)

        @services = {}
      end

      def soft_clone
        Client.new(access_key, secret_key, opts.merge(current_project: current_project))
      end

      %w(get put post delete options head).each do |method|
        define_method(method) do |*args|
          if @current_project
            options = args.last.is_a?(Hash) ? args.pop : {}
            options[:query] = (options[:query] || {}).merge(curr_project: @current_project)
            args = args.push(options)
          end
          http.send(method, *args)
        end
      end

      private

      def http
        @http ||= Http.new(access_key, secret_key, @opts[:endpoint])
      end
    end
  end
end
