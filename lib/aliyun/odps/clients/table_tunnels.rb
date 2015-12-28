require 'aliyun/odps/struct/project'

module Aliyun
  module Odps
    module Clients
      # Methods for TableTunnels
      module TableTunnels

        # require 'aliyun/odps/clients/download_sessions'
        #
        # class DownloadSessionsService < Aliyun::Odps::Struct::Project::ProjectService
        #   include Clients::DownloadSessions
        # end
        #
        # require 'aliyun/odps/clients/upload_sessions'
        #
        # class UploadSessionsService < Aliyun::Odps::Struct::Project::ProjectService
        #   include Clients::UploadSessions
        # end
        #
        # def download_sessions
        #   @services ||= {}
        #   @services[:download_sessions] = DownloadSessionsService.new(client, project)
        # end
        #
        # def upload_sessions
        #   @services ||= {}
        #   @services[:upload_sessions] = UploadSessionsService.new(client, project)
        # end

      end
    end
  end
end
