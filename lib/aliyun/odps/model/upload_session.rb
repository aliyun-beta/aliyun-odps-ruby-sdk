require 'aliyun/odps/clients/upload_sessions'

module Aliyun
  module Odps
    class UploadSession
      extend Aliyun::Odps::Modelable
    end
    class UploadSessionService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::UploadSessions
    end
  end
end
