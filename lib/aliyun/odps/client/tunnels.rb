module Aliyun
  module Odps
    class Client
      # Methods for Tunnels
      module Tunnels

        def download_sessions
          @services ||= {}
          @services[:download_sessions] = Client::DownloadSessionsService.new(client)
        end

        def upload_sessions
          @services ||= {}
          @services[:upload_sessions] = Client::UploadSessionsService.new(client)
        end

      end
    end
  end
end
