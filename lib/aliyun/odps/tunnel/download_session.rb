require 'odps_protobuf'

module Aliyun
  module Odps
    class DownloadSession < Struct::Base
      def_attr :project, Project, required: true
      def_attr :client, Client, required: true

      def_attr :download_id, String, required: true
      def_attr :table_name, String, required: true
      def_attr :partition_spec, String
      def_attr :record_count, Integer
      def_attr :status, String
      def_attr :owner, String
      def_attr :initiated, DateTime
      def_attr :schema, Hash

      # Download data
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/get_table_download_id/index.html Get Download Block ID
      #
      # @param rowrange [String] specify data range with format: [start, end]
      # @param columns [Array] specify columns need download in array
      # @param encoding [String] specify the data compression format, supported value: raw, deflate, snappy
      #
      # @return [Raw Data] return the raw data from ODPS
      def download(rowrange, columns, encoding = 'raw')
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = {
          data: true,
          downloadid: download_id,
          columns: columns.join(','),
          rowrange: "(#{rowrange.join(',')})"
        }

        query.merge!(partition: partition_spec) if partition_spec

        headers = { 'x-odps-tunnel-version' => TableTunnels::TUNNEL_VERSION }

        case encoding.to_s.downcase
        when 'deflate'
          headers['Accept-Encoding'] = 'deflate'
        when 'snappy'
          headers['Accept-Encoding'] = 'x-snappy-framed'
        when 'raw'
          headers.delete('Accept-Encoding')
        else
          fail ValueNotSupportedError.new(:encoding, TableTunnels::SUPPORTED_ENCODING)
        end

        resp = client.get(path, query: query, headers: headers)
        protobufed2records(resp.parsed_response)
      end

      private

      def protobufed2records(protobufed_str)
        deserializer = OdpsProtobuf::Deserializer.new
        deserializer.deserialize(protobufed_str, schema)
      end
    end
  end
end
