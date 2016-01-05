require 'odps_protobuf'

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

        query = {
          data: true,
          downloadid: download_id,
          columns: columns.join(','),
          rowrange: "(#{start},#{count})"
        }

        query.merge!(partition: partition_spec) if partition_spec

        headers = { 'x-odps-tunnel-version' => TableTunnels::TUNNEL_VERSION }

        case encoding
        when 'deflate'
          headers['Accept-Encoding'] = 'deflate'
        when 'snappy'
          # fail NotImplementedError
          headers['Accept-Encoding'] = 'x-snappy-framed'
        when 'raw'
          headers.delete('Accept-Encoding')
        else
          fail ValueNotSupportedError.new(:encoding, TableTunnels::SUPPORTED_ENCODING)
        end

        resp = client.get(path, query: query, headers: headers)
        p resp.headers
        protobufed2records(resp.parsed_response, resp.headers['content-encoding'])
      end

      private

      def protobufed2records(data, encoding)
        p encoding
        data =
          case encoding
          when 'deflate'
            data
          when 'x-snappy-framed'
            data
            # fail NotImplementedError
            # begin
            # require 'snappy'
            # rescue LoadError
            # fail "Install snappy to support x-snappy-framed encoding: https://github.com/miyucy/snappy"
            # end
            # Snappy.inflate(data)
          else
            data
          end
        p data

        deserializer = OdpsProtobuf::Deserializer.new
        deserializer.deserialize(data, schema)
      end
    end
  end
end
