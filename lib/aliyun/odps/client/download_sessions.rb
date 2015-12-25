module Aliyun
  module Odps
    class Client
      # Methods for DownloadSessions
      module DownloadSessions

        # Init Download Session
        #
        # @see http://repo.aliyun.com/api-doc/Tunnel/post_create_download_session/index.html Post Download Session
        #
        # @params table_name [String] specify table name
        # @params partition_spec [String] specify partition spec
        def init(table_name, partition_spec = nil)
          path = "/projects/#{client.current_project}/tables/#{table_name}"
          query = { downloads: true }
          query.merge!(partition: partition_spec) if partition_spec

          resp = client.post(path, query: query)
          #binding.pry
          result = resp.parsed_response
          result = JSON.parse(result) if result.is_a?(String)
          p result

          Struct::DownloadSession.new(result.merge(
            table_name: table_name,
            partition_spec: partition_spec
          ))
        end

      end
    end
  end
end
