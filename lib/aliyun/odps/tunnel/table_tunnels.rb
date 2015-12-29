require 'aliyun/odps/tunnel/download_sessions'
require 'aliyun/odps/tunnel/upload_sessions'

module Aliyun
  module Odps
    # Methods for TableTunnels
    class TableTunnels < ServiceObject
      extend Aliyun::Odps::Modelable

      has_many :download_sessions
      has_many :upload_sessions
    end
  end
end
