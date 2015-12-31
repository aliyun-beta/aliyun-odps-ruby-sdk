require 'stringio'

module Aliyun
  module Odps
    class UploadSession < Struct::Base
      def_attr :project, :Project, required: true
      def_attr :client, :Client, required: true

      def_attr :upload_id, :String, required: true
      def_attr :table_name, :String, required: true
      def_attr :partition_spec, :String
      def_attr :status, :String
      def_attr :owner, :String
      def_attr :initiated, :DateTime
      def_attr :schema, :Hash
      def_attr :blocks, :Array, init_with: ->(value) do
        value.map { |v| UploadBlock.new(v) }
      end

      alias_method :uploaded_block_list=, :blocks=

      # Upload data with block id
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/put_create_upload_id/index.html Put Upload Block ID
      #
      # @param block_id [String] specify block_id for this upload, range in 0~19999, new block with replace with old with same blockid
      # @param record_values [Array<Array>] specify the data, a array for your record, with order matched with your schema
      # @param encoding [String] specify the data compression format, supported value: raw, deflate, snappy
      #
      # @return [true]
      def upload(block_id, record_values, encoding = 'raw')
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { blockid: block_id, uploadid: upload_id }
        query[:partition] = partition_spec if partition_spec

        headers = {
          'x-odps-tunnel-version' => TableTunnels::TUNNEL_VERSION,
          'Transfer-Encoding' => 'chunked'
        }

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

        body = generate_body_for_upload(record_values)

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

      def generate_body_for_upload(record_values)
        stream = StringIO.new
        records = record_values.map { |value| value_to_record(value) }
        serializer = Serializer.new
        serializer.serialize(stream, records)
        stream.string
      end

      def value_to_record(value)
        schema = Aliyun::Odps::OdpsTableSchema.new(self.schema)
        fail 'value must be a array' unless value.is_a? Array

        if value.count != schema.getColumnCount
          fail 'column counts are not equal between value and schema'
        end

        record = OdpsTableRecord.new(schema)
        i = 0
        while i < value.count
          type = schema.getColumnType(i)
          if value[i].nil?
            record.setNullValue(i)
            i += 1
            next
          end
          case type
          when $ODPS_BIGINT
            record.setBigInt(i, value[i])
          when $ODPS_BOOLEAN
            record.setBoolean(i, value[i])
          when $ODPS_DATETIME
            record.setDateTime(i, value[i])
          when $ODPS_DOUBLE
            record.setDouble(i, value[i])
          when $ODPS_STRING
            record.setString(i, value[i])
          when $ODPS_DECIMAL
            record.setDecimal(i, value[i])
          else
            fail 'unsupported schema type'
          end
          i += 1
        end
        record
      end
    end
  end
end
