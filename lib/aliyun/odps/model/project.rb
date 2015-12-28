require 'aliyun/odps/clients/projects'
require 'aliyun/odps/model/instance'
require 'aliyun/odps/model/table'
require 'aliyun/odps/model/function'
require 'aliyun/odps/model/resource'
require 'aliyun/odps/model/table_tunnel'

module Aliyun
  module Odps
    module Model
      class Project < Struct::Base
        extend Aliyun::Odps::Modelable

        has_many :instances
        has_many :functions
        has_many :tables
        has_many :resources
        has_many :table_tunnels

        # def_attr :client, :Client, required: true
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

      class ProjectService < Aliyun::Odps::ServiceObject
        include Aliyun::Odps::Clients::Projects
      end
    end
  end
end
