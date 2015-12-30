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

      # Upload data in block
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/put_create_upload_id/index.html Put Upload Block ID
      #
      # @params blockid [String] specify blockid for this upload, range in 0~19999, new block with replace with old with same blockid
      # @params file_or_bin [File|Bin Data] specify the data, a local file path or raw data
      # @params encoding [String] specify the data compression format, supported value: raw, deflate, snappy
      def upload(blockid, file_or_bin, encoding = 'raw')
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { blockid: blockid, uploadid: upload_id }
        query[:partition] = partition_spec if partition_spec

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

        !!client.put(path, query: query, headers: headers, body: Utils.to_data(file_or_bin))
      end

      # reload upload session status
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/get_upload_session_status/index.html Get Upload Session Status
      #
      # @return UploadSession
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

      # Complete a upload session
      #
      # @see http://repo.aliyun.com/api-doc/Tunnel/post_commit_upload_session/index.html Post commit Upload Session
      #
      # @return true
      def complete
        path = "/projects/#{project.name}/tables/#{table_name}"

        query = { uploadid: upload_id }
        query.merge!(partition: partition_spec) if partition_spec

        headers = { 'x-odps-tunnel-version' => TableTunnels::TUNNEL_VERSION }

        !!client.post(path, query: query, headers: headers)
      end
    end
  end
end
