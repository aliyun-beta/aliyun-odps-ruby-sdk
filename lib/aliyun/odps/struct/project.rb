module Aliyun
  module Odps
    module Struct
      class Project < Base

        def_attr :client, :Client, required: true

        def_attr :name, :String, required: true
        def_attr :comment, :String
        def_attr :project_group_name, :String
        def_attr :state, :String
        def_attr :clusters, :Hash
        def_attr :property, :String
        def_attr :properties, :Hash

        attr_reader :services

        # ProjectService = ::Struct.new(:client, :project)
        #
        # require 'aliyun/odps/client/tables'
        #
        # class TablesService < ProjectService
        #   include Client::Tables
        # end
        #
        # require 'aliyun/odps/client/resources'
        #
        # class ResourcesService < ProjectService
        #   include Client::Resources
        # end
        #
        # require 'aliyun/odps/client/instances'
        #
        # class InstancesService < ProjectService
        #   include Client::Instances
        # end
        #
        # require 'aliyun/odps/client/functions'
        #
        # class FunctionsService < ProjectService
        #   include Client::Functions
        # end
        #
        # require 'aliyun/odps/client/table_tunnels'
        #
        # class TableTunnelsService < ProjectService
        #   include Client::TableTunnels
        # end
        #
        #
        # def tables
        #   @services ||= {}
        #   @services[:tables] = TablesService.new(client, self)
        # end
        #
        # def functions
        #   @services ||= {}
        #   @services[:functions] = FunctionsService.new(client, self)
        # end
        #
        # def resources
        #   @services ||= {}
        #   @services[:resources] = ResourcesService.new(client, self)
        # end
        #
        # def instances
        #   @services ||= {}
        #   @services[:instances] = InstancesService.new(client, self)
        # end
        #
        # def table_tunnels
        #   @services ||= {}
        #   @services[:table_tunnels] ||= TableTunnelsService.new(client, self)
        # end

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
end
