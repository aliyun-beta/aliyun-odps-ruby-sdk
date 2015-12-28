require 'aliyun/odps/clients/table_tunnels'

module Aliyun
  module Odps
    module Model
    class TableTunnel
      extend Aliyun::Odps::Modelable

      has_many :download_sessions
      has_many :upload_sessions
    end
    class TableTunnelService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::TableTunnels
    end
  end
  end
end

