require 'aliyun/odps/tunnel/download_sessions'
require 'aliyun/odps/tunnel/upload_sessions'

module Aliyun
  module Odps
    # Methods for TableTunnels
    class TableTunnels < ServiceObject
      extend Aliyun::Odps::Modelable

      has_many :download_sessions
      has_many :upload_sessions

      def client
        config = Aliyun::Odps.config.dup
        config.endpoint = TunnelRouter.get_tunnel_endpoint(project.client, project.name)
        Aliyun::Odps::Client.new(config)
      end
    end
  end
end
