module Aliyun
  module Odps
    module Clients
      # Methods for DownloadSessions
      module DownloadSessions

        # Init Download Session
        #
        # @see http://repo.aliyun.com/api-doc/Tunnel/post_create_download_session/index.html Post Download Session
        #
        # @params table_name [String] specify table name
        # @params partition [Hash] specify partition spec, format: { 'key1': 'value1', 'key2': 'value2' }
        def init(table_name, partition = {})
          path = "/projects/#{project.name}/tables/#{table_name}"
          query = { downloads: true }

          unless partition.empty?
            query.merge!(partition: generate_partition_spec(partition))
          end

          resp = client.post(path, query: query)

          result = resp.parsed_response
          result = JSON.parse(result) if result.is_a?(String)

          Model::DownloadSession.new(result.merge(
            project: project,
            client: client,
            table_name: table_name,
            partition_spec: query[:partition]
          ))
        end

        private

        def generate_partition_spec(partition)
          partition.map { |k, v| "#{k}=#{v}" }.join(',')
        end

      end
    end
  end
end
