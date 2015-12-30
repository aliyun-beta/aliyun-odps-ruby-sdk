module Aliyun
  module Odps
    class TunnelRouter
      def self.get_tunnel_endpoint(client, project_name)
        host = client.get(
          "/projects/#{project_name}/tunnel",
          query: { service: true, curr_project: project_name }
        ).parsed_response
        "#{Aliyun::Odps.config.protocol}://#{host}"
      rescue RequestError
        nil
      end
    end
  end
end
