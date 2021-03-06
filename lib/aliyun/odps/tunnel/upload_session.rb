require 'odps_protobuf'
require 'aliyun/odps/tunnel/snappy_writer'

module Aliyun
  module Odps
    class UploadSession < Struct::Base
      property :project, :Project, required: true
      property :client, :Client, required: true

      property :upload_id, :String, required: true
      property :table_name, :String, required: true
      property :partition_spec, :String
      property :status, :String
      property :owner, :String
      property :initiated, :DateTime
      property :schema, :Hash
      property :blocks, :Array, init_with: ->(value) do
        value.map { |v| UploadBlock.new(v) }
      end

      alias_method :uploaded_block_list=, :blocks=

      # Upload data with block id
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/put_create_upload_id/index.html Put Upload Block ID
      #
      # @param block_id [String] specify block_id for this upload, range in 0~19999, new block with replace with old with same blockid
      # @param record_values [Array<Array>] specify the data, a array for your record, with order matched with your schema
      # @param encoding [String] specify the data compression format, supported value: raw, deflate
      #
      # @return [true]
      def upload(block_id, record_values, encoding = 'raw')
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { blockid: block_id, uploadid: upload_id }
        query[:partition] = partition_spec if partition_spec

        headers = build_upload_headers(encoding)
        body = generate_upload_body(record_values, encoding)

        !!client.put(path, query: query, headers: headers, body: body)
      end

      # reload this upload session
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/get_upload_session_status/index.html Get Upload Session Status
      #
      # @return [UploadSession]
      def reload
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { uploadid: upload_id }
        query.merge!(partition: partition_spec) if partition_spec

        resp = client.get(path, query: query)

        result = resp.parsed_response
        attrs = result.is_a?(String) ? JSON.parse(result) : result

        update_attrs(attrs)
      end

      # List uploaded blocks
      #
      # @return [Array<UploadBlock>]
      def list_blocks
        reload
        blocks
      end

      # Complete the upload session
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/post_commit_upload_session/index.html Post commit Upload Session
      #
      # @return [true]
      def complete
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { uploadid: upload_id }
        query.merge!(partition: partition_spec) if partition_spec

        headers = { 'x-odps-tunnel-version' => TableTunnels::TUNNEL_VERSION }

        !!client.post(path, query: query, headers: headers)
      end

      private

      def generate_upload_body(record_values, encoding)
        serializer = OdpsProtobuf::Serializer.new
        data = serializer.serialize(record_values, schema)
        compress_data(data, encoding)
      rescue
        raise RecordNotMatchSchemaError.new(record_values, schema)
      end

      def compress_data(data, encoding)
        case encoding
        when 'raw'
          data
        when 'deflate'
          require 'zlib'
          Zlib::Deflate.deflate(data)
        when 'snappy'
          SnappyWriter.compress(data)
        end
      end

      def set_content_encoding(headers, encoding)
        case encoding.to_s.downcase
        when 'deflate'
          headers['Content-Encoding'] = 'deflate'
        when 'snappy'
          headers['Content-Encoding'] = 'x-snappy-framed'
        when 'raw'
          headers.delete('Content-Encoding')
        else
          fail ValueNotSupportedError.new(:encoding, TableTunnels::SUPPORTED_ENCODING)
        end
      end

      def build_upload_headers(encoding)
        headers = {
          'x-odps-tunnel-version' => TableTunnels::TUNNEL_VERSION,
          'Transfer-Encoding' => 'chunked'
        }
        set_content_encoding(headers, encoding)
        headers
      end
    end
  end
end
