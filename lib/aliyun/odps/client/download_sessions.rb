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
        def init(table_name, partition_spec)
          path = "/projects/#{client.current_project}/tables/#{table_name}"
          query = { downloads: true, partition: partition_spec }
          result = client.get(path, query: query).parsed_response

          Struct::DownloadSession.new(result.merge(
            table_name: table_name,
            partition_spec: partition_spec,
            client: client.soft_clone
          ))
        end

      end
    end
  end
end
