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
        # @params options [Hash] options
        # @option options [String] :partition_spec  specify partition spec
        # @option options [String] :tunnel_version specify odps tunnel version
        def init(table_name, options = {})
          Utils.stringify_keys!(options)
          path = "/projects/#{project.name}/tables/#{table_name}"
          query = { uploads: true }
          query.merge!( partition: options['partition_spec'] ) if options.key?('partition_spec')

          headers = {}
          headers.merge!( "x-odps-tunnel-version" => options['tunnel_version'] ) if options.key?('tunnel_version')

          resp = client.post(path, query: query, headers: headers)
          result = resp.parsed_response
          result = JSON.parse(result) if result.is_a?(String)

          Struct::UploadSession.new(result.merge(
            project: project,
            client: client,
            table_name: table_name,
            partition_spec: options['partition_spec']
          ))
        end

      end
    end
  end
end
