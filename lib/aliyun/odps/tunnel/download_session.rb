require 'odps_protobuf'
require 'aliyun/odps/tunnel/snappy_reader'

module Aliyun
  module Odps
    class DownloadSession < Struct::Base
      property :project, Project, required: true
      property :client, Client, required: true

      property :download_id, String, required: true
      property :table_name, String, required: true
      property :partition_spec, String
      property :record_count, Integer
      property :status, String
      property :owner, String
      property :initiated, DateTime
      property :schema, Hash

      # Download data
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/get_table_download_id/index.html Get Download Block ID
      #
      # @param start [String] specify start download row number
      # @param count [String] specify download row count
      # @param columns [Array] specify columns need download in array
      # @param encoding [String] specify the data compression format, supported value: raw, deflate
      #
      # @return [Raw Data] return the raw data from ODPS
      def download(start, count, columns, encoding = 'raw')
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = build_download_query(start, count, columns)
        headers = build_download_headers(encoding)

        resp = client.get(path, query: query, headers: headers)
        protobufed2records(resp.parsed_response, resp.headers['content-encoding'], columns)
      end

      private

      def build_download_query(start, count, columns)
        query = {
          data: true,
          downloadid: download_id,
          columns: columns.join(','),
          rowrange: "(#{start},#{count})"
        }
        query[:partition] = partition_spec if partition_spec
        query
      end

      def protobufed2records(data, encoding, columns)
        data = uncompress_data(data, encoding)
        deserializer = OdpsProtobuf::Deserializer.new
        schema = build_schema_with(columns)
        deserializer.deserialize(data, schema)
      rescue
        raise RecordNotMatchSchemaError.new(columns, schema)
      end

      def uncompress_data(data, encoding)
        case encoding
        when 'deflate'
          data
        when 'x-snappy-framed'
          SnappyReader.uncompress(data)
        else
          data
        end
      end

      def build_download_headers(encoding)
        headers = { 'x-odps-tunnel-version' => TableTunnels::TUNNEL_VERSION }
        set_accept_encoding(headers, encoding)
        headers
      end

      def set_accept_encoding(headers, encoding)
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
      end

      def build_schema_with(columns)
        {
          'columns' => schema['columns'].select { |column| columns.include?(column['name']) }
        }
      end
    end
  end
end
