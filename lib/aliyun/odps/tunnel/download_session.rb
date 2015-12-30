module Aliyun
  module Odps
    class DownloadSession < Struct::Base

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
      # @params encoding [String] specify the data compression format, supported value: raw, deflate, snappy
      def download(rowrange, columns, encoding = 'raw')
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = {
          data: true,
          downloadid: download_id,
          columns: URI.escape(columns),
          rowrange: URI.escape(rowrange)
        }
        query.merge!(partition: partition_spec) if partition_spec

        headers = { 'x-odps-tunnel-version' => TableTunnels::TUNNEL_VERSION }

        case encoding.to_s.downcase
        when 'deflate'
          headers['Content-Encoding'] = 'deflate'
        when 'snappy'
          headers['Content-Encoding'] = 'x-snappy-framed'
        when 'raw'
        else
          fail ValueNotSupportedError.new(:encoding, TableTunnels::SUPPORTED_ENCODING)
        end

        client.get(path, query: query, headers: headers).parsed_response
      end
    end
  end
end
