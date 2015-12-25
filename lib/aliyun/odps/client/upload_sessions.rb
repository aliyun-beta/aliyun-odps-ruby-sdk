module Aliyun
  module Odps
    class Client
      # Methods for UploadSessions
      module UploadSessions

        # Init Download Session
        #
        # @see http://repo.aliyun.com/api-doc/Tunnel/post_create_download_session/index.html Post Download Session
        #
        # @params table_name [String] specify table name
        # @params partition_spec [String] specify partition spec
        # @params options [Hash] options
        # @option options [String] :tunnel_version specify odps tunnel version
        def init(table_name, partition_spec, options = {})
          path = "/projects/#{client.current_project}/tables/#{table_name}"
          query = { uploads: true, partition: partition_spec }

          headers = {}
          headers.merge( "x-odps-tunnel-version" => options['tunnel_version'] ) if options.key?('tunnel_version')

          result = client.get(path, query: query, headers: headers).parsed_response

          Struct::UploadSession.new(result.merge(
            table_name: table_name,
            partition_spec: partition_spec,
            client: client.soft_clone
          ))
        end

      end
    end
  end
end
