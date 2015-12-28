module Aliyun
  module Odps
    module Struct
      class DownloadSession < Base

        def_attr :project, :Project, required: true
        def_attr :client, :Client, required: true

        def_attr :download_id, :String, required: true
        def_attr :table_name, :String, required: true
        def_attr :partition_spec, :String
        def_attr :record_count, :Integer
        def_attr :status, :String
        def_attr :owner, :String
        def_attr :initiated, :DateTime
        def_attr :schema, :String

        # Download data in block
        #
        # @see http://repo.aliyun.com/api-doc/Tunnel/get_table_download_id/index.html Get Download Block ID
        #
        # @params rowrange [String] specify data range with format: "(start,end)"
        # @params columns [String] specify columns need download with format: "col0,col1,col2"
        # @params options [Hash] options
        # @option options [String] :tunnel_version specify the Tunnel version
        # @option options [String] :encoding specify the data compression format, supported value: Raw, Zlib, snappy
        def download(rowrange, columns, options = {})
          Utils.stringify_keys!(options)
          path = "/projects/#{project.name}/tables/#{table_name}"

          query = { data: true, downloadid: download_id, columns: columns, rowrange: rowrange }
          query.merge!(partition: options['partition_spec']) if options.key?('partition_spec')

          headers = {}
          headers.merge!( "x-odps-tunnel-version" => options["tunnel_version"] ) if options.key?('tunnel_version')
          headers.merge!( "Accept-Encoding" => options["encoding"] ) if options.key?('encoding')

          client.get(path, query: query, headers: headers).parsed_response
        end

      end
    end
  end
end
