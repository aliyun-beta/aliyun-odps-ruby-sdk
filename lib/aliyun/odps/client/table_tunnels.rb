require 'aliyun/odps/struct/project'

module Aliyun
  module Odps
    class Client
      # Methods for TableTunnels
      module TableTunnels

        require 'aliyun/odps/client/download_sessions'

        class DownloadSessionsService < Aliyun::Odps::Struct::Project::ProjectService
          include Client::DownloadSessions
        end

        require 'aliyun/odps/client/upload_sessions'

        class UploadSessionsService < Aliyun::Odps::Struct::Project::ProjectService
          include Client::UploadSessions
        end

        def download_sessions
          @services ||= {}
          @services[:download_sessions] = DownloadSessionsService.new(client, project)
        end

        def upload_sessions
          @services ||= {}
          @services[:upload_sessions] = UploadSessionsService.new(client, project)
        end

      end
    end
  end
end
