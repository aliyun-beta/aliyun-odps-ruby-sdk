require 'aliyun/odps/version'
require 'aliyun/odps/error'
require 'aliyun/odps/configuration'
require 'aliyun/odps/struct'
require 'aliyun/odps/modelable'
require 'aliyun/odps/project'

require 'aliyun/odps/authorization'
require 'aliyun/odps/client'
require 'aliyun/odps/utils'
require 'aliyun/odps/list'

# DEBUG
require 'pry'

module Aliyun
  module Odps
    class << self
      attr_writer :configuration

      # Config Odps
      #
      # @example
      #
      #  Aliyun::Odps.configure do |config|
      #    config.access_key = 'your-access-key'
      #    config.secret_key = 'your-secret-key'
      #    config.endpoint = 'odps-api-endpoint'  # 'http://service.odps.aliyun.com/api' or 'http://odps-ext.aliyun-inc.com/api'
      #    config.project = 'your-default-project-name'
      #    config.tunnel_endpoint = 'odps-tunnel-api-endpoint'  # if you not config it, we will auto detect it
      #  end
      def configure
        @configuration ||= Configuration.new
        yield @configuration if block_given?
        @configuration
      end

      # return current configuration
      #
      # @return [Configuration]
      def config
        @configuration
      end

      # Get project
      #
      # @param name [String] specify project name, default is project in config
      #
      # @return [Project]
      def project(name = config.project)
        fail MissingProjectConfigurationError unless name
        client.projects.get(name)
      end
      alias_method :get_project, :project

      # (see Projects#list)
      def list_projects(options = {})
        client.projects.list(options)
      end
      alias_method :projects, :list_projects

      # (see Projects#update)
      def update_project(name, options = {})
        client.projects.update(name, options)
      end

      private

      def client
        @client ||= Aliyun::Odps::Client.new
      end
    end
  end
end
