require 'aliyun/odps/clients/download_sessions'

module Aliyun
  module Odps
    class DownloadSession
      extend Aliyun::Odps::Modelable
    end
    class DownloadSessionService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::DownloadSessions
    end
  end
end
