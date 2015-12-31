require 'aliyun/odps/model/instances'
require 'aliyun/odps/model/tables'
require 'aliyun/odps/model/functions'
require 'aliyun/odps/model/resources'
require 'aliyun/odps/tunnel/table_tunnels'
require 'aliyun/odps/client'

module Aliyun
  module Odps
    class Project < Struct::Base
      extend Aliyun::Odps::Modelable

      # @!method instances
      # @return [Instances]
      has_many :instances

      # @!method functions
      # @return [Functions]
      has_many :functions

      # @!method tables
      # @return [Tables]
      has_many :tables

      # @!method resources
      # @return [Resources]
      has_many :resources

      # @!method table_tunnels
      # @return [TableTunnels]
      has_many :table_tunnels

      def_attr :client, Client, required: true

      def_attr :name, String, required: true
      def_attr :comment, String
      def_attr :project_group_name, String
      def_attr :state, String
      def_attr :clusters, Hash
      def_attr :property, String
      def_attr :properties, Hash
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'model/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'tunnel/*.rb')].each { |f| require f }
