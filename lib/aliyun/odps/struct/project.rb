module Aliyun
  module Odps
    module Struct
      class Project < Base
        attr_accessor :name

        attr_accessor :comment

        attr_accessor :project_group_name

        attr_accessor :state

        attr_accessor :clusters

        attr_accessor :property

        attr_accessor :properties

        attr_accessor :client

        attr_reader :services

        ProjectService = ::Struct.new(:client, :project)

        require 'aliyun/odps/client/tables'

        class TablesService < ProjectService
          include Client::Tables
        end

        require 'aliyun/odps/client/resources'

        class ResourcesService < ProjectService
          include Client::Resources
        end

        require 'aliyun/odps/client/instances'

        class InstancesService < ProjectService
          include Client::Instances
        end

        require 'aliyun/odps/client/functions'

        class FunctionsService < ProjectService
          include Client::Functions
        end

        require 'aliyun/odps/client/table_tunnels'

        class TableTunnelsService < ProjectService
          include Client::TableTunnels
        end


        def tables
          @services ||= {}
          @services[:tables] = TablesService.new(client, self)
        end

        def functions
          @services ||= {}
          @services[:functions] = FunctionsService.new(client, self)
        end

        def resources
          @services ||= {}
          @services[:resources] = ResourcesService.new(client, self)
        end

        def instances
          @services ||= {}
          @services[:instances] = InstancesService.new(client, self)
        end

        def table_tunnels
          @services ||= {}
          @services[:table_tunnels] ||= TableTunnelsService.new(client, self)
        end
      end
    end
  end
end
