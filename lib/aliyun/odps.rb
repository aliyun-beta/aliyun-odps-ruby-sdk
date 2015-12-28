require 'aliyun/odps/version'
require 'aliyun/odps/list'
require 'aliyun/odps/utils'
require 'aliyun/odps/authorization'
require 'aliyun/odps/configuration'
require 'aliyun/odps/struct'
require 'aliyun/odps/modelable'
require 'aliyun/odps/client'
require 'aliyun/odps/tunnel_router'

# DEBUG
require 'pry'

module Aliyun
  module Odps
    # Your code goes here...
    class << self
      attr_writer :configuration, :world
    end

    def self.configure
      @configuration ||= Configuration.new
      yield @configuration if block_given?
      @configuration
    end

    def self.config
      @configuration
    end

    def self.project
      fail MissingProjectConfigurationError unless config.project

      Aliyun::Odps::Model::Project.new(
        name: config.project
      )
    end
  end
end
