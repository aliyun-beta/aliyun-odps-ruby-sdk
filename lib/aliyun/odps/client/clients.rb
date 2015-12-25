module Aliyun
  module Odps
    #
    #
    class Client
      def projects
        @services[:projects] = Client::ProjectsService.new(self)
      end

      def tunnels
        @services[:tunnels] ||= Client::TunnelsService.new(self)
      end

      ClientService = ::Struct.new(:client)

      require 'aliyun/odps/client/projects'

      class ProjectsService < ClientService
        include Client::Projects
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

      require 'aliyun/odps/client/download_sessions'

      class DownloadSessionsService < ClientService
        include Client::DownloadSessions
      end

      require 'aliyun/odps/client/upload_sessions'

      class UploadSessionsService < ClientService
        include Client::UploadSessions
      end
    end
  end
end
