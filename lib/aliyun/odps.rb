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

    # Your code goes here...
    class << self
      attr_writer :configuration

      def configure
        @configuration ||= Configuration.new
        yield @configuration if block_given?
        @configuration
      end

      def config
        @configuration
      end

      def project(name = nil)
        fail MissingProjectConfigurationError unless config.project

        Aliyun::Odps::Project.new(
          name: name || config.project,
          client: Aliyun::Odps::Client.new
        )
      end
    end
  end
end
