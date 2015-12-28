module Aliyun
  module Odps
    class TunnelRouter

      def initialize(client)
        @client = client
      end

      def get_tunnel_endpoint(project_name)
        host = @client.get(
          "/projects/#{project_name}/tunnel",
          query: { service: true, curr_project: project_name }
        ).parsed_response
        "#{Aliyun::Odps.config.protocol}://#{host}"
      rescue RequestError => e
        nil
      end
    end
  end
end
