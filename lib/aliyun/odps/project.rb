require 'aliyun/odps/model/instances'
require 'aliyun/odps/model/tables'
require 'aliyun/odps/model/functions'
require 'aliyun/odps/model/resources'
require 'aliyun/odps/tunnel/table_tunnels'

module Aliyun
  module Odps
    class Project < Struct::Base
      extend Aliyun::Odps::Modelable

      has_many :instances
      has_many :functions
      has_many :tables
      has_many :resources
      has_many :table_tunnels

      def_attr :client, :Client, required: true

      def_attr :name, :String, required: true
      def_attr :comment, :String
      def_attr :project_group_name, :String
      def_attr :state, :String
      def_attr :clusters, :Hash
      def_attr :property, :String
      def_attr :properties, :Hash

      def build_update_body
        fail XmlElementMissingError, 'Comment' if comment.nil?

        Utils.to_xml(
          'Project' => {
            'Name' => name,
            'Comment' => comment
          })
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'model/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'tunnel/*.rb')].each { |f| require f }
