require 'aliyun/odps/clients/table_tunnels'

module Aliyun
  module Odps
    class TableTunnel
      extend Aliyun::Odps::Modelable
    end
    class TableTunnelService < Aliyun::Odps::ServiceObject
      include Aliyun::Odps::Clients::TableTunnels
    end
  end
end
