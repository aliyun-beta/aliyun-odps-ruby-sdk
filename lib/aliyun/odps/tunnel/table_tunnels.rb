module Aliyun
  module Odps
    class TableTunnels < ServiceObject
      TUNNEL_VERSION = '4'
      SUPPORTED_ENCODING = %w(raw deflate snappy)

      def client
        config = Aliyun::Odps.config.dup
        config.endpoint = TunnelRouter.get_tunnel_endpoint(project.client, project.name) || Aliyun::Odps.config.tunnel_endpoint
        fail TunnelEndpointMissingError if config.endpoint.nil?
        Aliyun::Odps::Client.new(config)
      end

      # Init Download Session
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/post_create_download_session/index.html Post Download Session
      #
      # @params table_name [String] specify table name
      # @params partition [Hash] specify partition spec, format: { 'key1': 'value1', 'key2': 'value2' }
      def init_download_session(table_name, partition = {})
        path = "/projects/#{project.name}/tables/#{table_name}"
        query = { downloads: true }
        unless partition.empty?
          query.merge!(partition: generate_partition_spec(partition))
        end

        resp = client.post(path, query: query)
        result = resp.parsed_response
        result = JSON.parse(result) if result.is_a?(String)

        build_download_session(result, table_name, query['partition'])
      end

      # Init Upload Session
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/post_create_upload_session/index.html Post Upload Session
      #
      # @params table_name [String] specify table name
      # @params partition [Hash] specify partition spec, format: { 'key1': 'value1', 'key2': 'value2' }
      def init_upload_session(table_name, partition = {})
        path = "/projects/#{project.name}/tables/#{table_name}"
        query = { uploads: true }
        unless partition.empty?
          query.merge!(partition: generate_partition_spec(partition))
        end

        resp = client.post(path, query: query)
        result = resp.parsed_response
        result = JSON.parse(result) if result.is_a?(String)

        build_upload_session(result, table_name, query['partition'])
      end

      private

      def generate_partition_spec(partition)
        partition.map { |k, v| "#{k}=#{v}" }.join(',')
      end

      def build_upload_session(result, table_name, partition_spec)
        UploadSession.new(
          result.merge(
            project: project,
            client: client,
            table_name: table_name,
            partition_spec: partition_spec
          ))
      end

      def build_download_session(result, table_name, partition_spec)
        DownloadSession.new(
          result.merge(
            project: project,
            client: client,
            table_name: table_name,
            partition_spec: partition_spec
          ))
      end
    end
  end
end
