module Aliyun
  module Odps
    #
    #
    class Client
      def projects
        @services[:projects] ||= Client::ProjectsService.new(self)
      end

      def tunnels
        @services[:tunnels] ||= Client::TunnelsService.new(self)
      end

      require 'aliyun/odps/client/projects'

      class ProjectsTablesService < ClientService
        def initialize
          @services = {}
        end

        def tables
          @services[:tables] ||= Client::TablesService.new(self)
        end

        def resources
          @services[:resources] ||= Client::ResourcesService.new(self)
        end

        def instances
          @services[:instances] ||= \
            Client::InstancesService.new(self)
        end

        def functions
          @services[:functions] ||= \
            Client::FunctionsService.new(self)
        end
      end

      require 'aliyun/odps/client/tunnels'

      class TunnelsService < ClientService
        include Client::Tunnels
      end

      require 'aliyun/odps/client/tables'

      class TablesService < ClientService
        include Client::Tables
      end

      require 'aliyun/odps/client/resources'

      class ResourcesService < ClientService
        include Client::Resources
      end

      require 'aliyun/odps/client/instances'

      class InstancesService < ClientService
        include Client::Instances
      end

      require 'aliyun/odps/client/functions'

      class FunctionsService < ClientService
        include Client::Functions
      end
    end
  end
end
