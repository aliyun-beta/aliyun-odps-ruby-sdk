module Aliyun
  module Odps
    module Struct
      class DownloadSession < Base

        attr_accessor :download_id

        attr_accessor :table_name

        attr_accessor :partition_spec

        attr_accessor :record_count

        attr_accessor :status

        attr_accessor :owner

        attr_accessor :initiated

        attr_accessor :schema

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
          path = "/projects/#{client.current_project}/tables/#{table_name}"

          query = { data: true, downloadid: download_id, columns: columns, rowrange: rowrange }
          query.merge!(partition: partition_spec) unless partition_spec.empty?

          headers = {}
          headers.merge!( "x-odps-tunnel-version" => options["tunnel_version"] ) if options.key?('tunnel_version')
          headers.merge!( "Accept-Encoding" => options["encoding"] ) if options.key?('encoding')

          client.get(path, query: query, headers: headers).parsed_response
        end

      end
    end
  end
end
